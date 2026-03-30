#!/usr/bin/env perl
#*****************************************************************************************
# statusline.pl
#
# My Claude Code status bar display script
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   7-Feb-2026  4:16pm
# Modified :  29-Mar-2026
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
use strict;
use warnings;
use JSON::PP;
use POSIX qw(strftime);

my $bar_width = 25;
my $json_text = do { local $/; <STDIN> };
my $data = decode_json($json_text);

my $model          = $data->{model}->{display_name} // 'unknown';
my $session_cost   = $data->{cost}->{total_cost_usd} // 0;
my $ctx_size       = $data->{context_window}->{context_window_size} // 0;
my $used_pct       = $data->{context_window}->{used_percentage} // 0;
my $five_hr_pct    = $data->{rate_limits}->{five_hour}->{used_percentage};
my $five_hr_reset  = $data->{rate_limits}->{five_hour}->{resets_at};
my $seven_day_pct  = $data->{rate_limits}->{seven_day}->{used_percentage};
my $seven_day_reset = $data->{rate_limits}->{seven_day}->{resets_at};

sub get_color {
    my ($percentage) = @_;
    return "\e[38;2;0;200;80m"  if $percentage < 60;
    return "\e[38;2;230;180;0m" if $percentage < 80;
    return "\e[38;2;220;50;50m";
}

sub create_bar {
    my ($percentage, $width) = @_;
    my $filled      = int(($percentage / 100) * $width);
    my $color       = get_color($percentage);
    my $reset       = "\e[0m";
    my $white       = "\e[38;2;255;255;255m\e[1m";
    my $label       = sprintf("%.1f%%", $percentage);
    my $label_len   = length($label);
    my $label_start = int(($width - $label_len) / 2);
    my $bar         = '';
    my $prev_mode   = '';

    for my $i (0 .. $width - 1) {
        my $is_label  = ($i >= $label_start && $i < $label_start + $label_len);
        my $is_filled = ($i < $filled);

        if ($is_label) {
            if ($prev_mode ne 'label') {
                $bar .= $reset . $white;
                $prev_mode = 'label';
            }
            $bar .= substr($label, $i - $label_start, 1);
        } elsif ($is_filled) {
            if ($prev_mode ne 'filled') {
                $bar .= $reset . $color;
                $prev_mode = 'filled';
            }
            $bar .= '█';
        } else {
            if ($prev_mode ne 'empty') {
                $bar .= $reset;
                $prev_mode = 'empty';
            }
            $bar .= '░';
        }
    }
    $bar .= $reset;
    return $bar;
}

sub format_clock {
    my ($epoch) = @_;
    return '' unless defined $epoch && $epoch > 0;
    my $time_str = lc(strftime("%-I:%M%p", localtime($epoch)));
    return $time_str;
}

sub format_calendar {
    my ($epoch) = @_;
    return '' unless defined $epoch && $epoch > 0;
    my $str = strftime("%a %-m/%-d", localtime($epoch));
    return $str;
}

my $cost_display = sprintf("\$%.2f", $session_cost);
my $ctx_display  = $ctx_size >= 1000 ? sprintf("%dk", $ctx_size / 1000) : $ctx_size;
my $ctx_bar      = create_bar($used_pct, $bar_width);

my $line = "$model | Cost: $cost_display | Ctx: ${ctx_display} $ctx_bar";

if (defined $five_hr_pct) {
    my $color = get_color($five_hr_pct);
    my $reset = "\e[0m";
    my $clock = format_clock($five_hr_reset);
    $line .= sprintf(" | 5h: ${color}%.0f%%${reset}", $five_hr_pct);
    $line .= " \e[2m$clock\e[0m" if $clock;
}

if (defined $seven_day_pct) {
    my $color = get_color($seven_day_pct);
    my $reset = "\e[0m";
    my $cal = format_calendar($seven_day_reset);
    $line .= sprintf(" | 7d: ${color}%.0f%%${reset}", $seven_day_pct);
    $line .= " \e[2m$cal\e[0m" if $cal;
}

print "$line\n";
