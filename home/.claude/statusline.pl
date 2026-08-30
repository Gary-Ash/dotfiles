#!/usr/bin/env perl
#*****************************************************************************************
# statusline.pl
#
# My Claude Code status bar display script
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   7-Feb-2026  4:16pm
# Modified :  17-Apr-2026 12:00pm
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
use strict;
use warnings;
use JSON::PP;
use POSIX qw(strftime floor);

my $bar_width = 16;
my $json_text = do { local $/; <STDIN> };
my $data      = decode_json($json_text);

my $model           = $data->{model}->{display_name}                      // 'unknown';
my $total_cost      = $data->{cost}->{total_cost_usd}                     // undef;
my $ctx_used_pct    = $data->{context_window}->{used_percentage}           // undef;
my $five_hr_pct     = $data->{rate_limits}->{five_hour}->{used_percentage} // undef;
my $five_hr_reset   = $data->{rate_limits}->{five_hour}->{resets_at}       // undef;
my $seven_day_pct   = $data->{rate_limits}->{seven_day}->{used_percentage} // undef;
my $seven_day_reset = $data->{rate_limits}->{seven_day}->{resets_at}       // undef;

# Returns the 24-bit fg color escape for a given percentage.
sub fill_color {
    my ($pct) = @_;
    return "\e[38;2;0;200;0m"   if $pct < 60;
    return "\e[38;2;220;200;0m" if $pct < 85;
    return "\e[38;2;220;40;40m";
}

# Returns the 24-bit bg color escape for a given percentage.
sub fill_bg_color {
    my ($pct) = @_;
    return "\e[48;2;0;200;0m"   if $pct < 60;
    return "\e[48;2;220;200;0m" if $pct < 85;
    return "\e[48;2;220;40;40m";
}

# Builds a fixed-width bar with the percentage label centered inside it.
# Cells in the filled portion use the color as background with dark text;
# cells in the unfilled portion use default background with color as foreground.
sub create_bar {
    my ($percentage, $width) = @_;
    my $filled      = int(($percentage / 100) * $width + 0.5);
    $filled         = $width if $filled > $width;
    my $fg          = fill_color($percentage);
    my $bg          = fill_bg_color($percentage);
    my $reset       = "\e[0m";
    my $label       = sprintf("%d%%", int($percentage + 0.5));
    my $label_len   = length($label);
    my $label_start = int(($width - $label_len) / 2);
    my $bar         = '';

    my $dark_bg  = "\e[48;2;147;161;161m";
    my $dark_fg  = "\e[38;2;147;161;161m";
    my $white_fg = "\e[38;2;255;255;255m";

    for my $i (0 .. $width - 1) {
        my $is_label  = ($i >= $label_start && $i < $label_start + $label_len);
        my $is_filled = ($i < $filled);
        my $char      = $is_label ? substr($label, $i - $label_start, 1) : "\x{2588}";

        if ($is_filled) {
            # filled: dark bg, colored fg block (or white for label digits)
            $bar .= $dark_bg . ($is_label ? $white_fg : $fg) . $char . $reset;
        } else {
            # unfilled: dark bg, dark fg block so it blends away (or white for label digits)
            $bar .= $dark_bg . ($is_label ? $white_fg : $dark_fg) . $char . $reset;
        }
    }
    return $bar;
}

# Formats an epoch as 12-hour clock: e.g. "3:05pm"
sub format_clock {
    my ($epoch) = @_;
    return '--' unless defined $epoch && $epoch > 0;
    my $str = strftime("%I:%M%p", localtime($epoch));
    $str =~ s/^0//;          # strip leading zero from hour
    return lc($str);
}

# Returns ordinal suffix for a day number.
sub ordinal_suffix {
    my ($n) = @_;
    return 'th' if $n =~ /1[123]$/;
    return 'st' if $n =~ /1$/;
    return 'nd' if $n =~ /2$/;
    return 'rd' if $n =~ /3$/;
    return 'th';
}

# Formats an epoch as calendar + time: e.g. "Thursday May 5th 4:00pm"
sub format_calendar {
    my ($epoch) = @_;
    return '--' unless defined $epoch && $epoch > 0;
    my @t       = localtime($epoch);
    my $day_num = $t[3];
    my $suffix  = ordinal_suffix($day_num);
    my $weekday = strftime("%A", @t);
    my $month   = strftime("%B", @t);
    my $time    = format_clock($epoch);
    return "$weekday $month ${day_num}${suffix} $time";
}

# --- Build output segments ---
my $sep = "  \e[38;2;100;100;100m|\e[0m  ";

my $line = "Model: \e[1m$model\e[0m";

if (defined $ctx_used_pct) {
    my $bar = create_bar($ctx_used_pct, $bar_width);
    $line .= $sep . "Context: $bar";
} else {
    $line .= $sep . "Context: --";
}

if (defined $five_hr_pct) {
    my $bar = create_bar($five_hr_pct, $bar_width);
    $line .= $sep . "Session: $bar";
} else {
    $line .= $sep . "Session: --";
}

$line .= $sep . "Session Reset: " . format_clock($five_hr_reset);

if (defined $seven_day_pct) {
    my $bar = create_bar($seven_day_pct, $bar_width);
    $line .= $sep . "Week: $bar";
} else {
    $line .= $sep . "Week: --";
}

$line .= $sep . "Week Reset: " . format_calendar($seven_day_reset);

if (defined $total_cost) {
    $line .= $sep . sprintf("Cost: \$%.2f", $total_cost);
}

print "$line\n";
