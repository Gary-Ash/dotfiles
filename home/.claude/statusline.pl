#!/usr/bin/env perl
#*****************************************************************************************
# statusline.pl
#
# My Claude Code status bar display script
#
# Author   :  Gary Ash <gary.ash@icloud.com>
# Created  :   8-Feb-2026  3:47pm
# Modified :
#
# Copyright © 2026 By Gary Ash All rights reserved.
#*****************************************************************************************
use strict;
use warnings;
use JSON::PP;

my $bar_width = 20;
my $json_text = do { local $/; <STDIN> };
my $data = decode_json($json_text);

my $model = $data->{model}->{display_name} // 'unknown';
my $tokens_used = $data->{used_tokens} // 0;
my $tokens_total = $data->{total_tokens} // 200000;
my $used_percentage = $data->{used_percentage} // 0;

my $output_used    = $data->{output_tokens} // 0;
my $rate_limit     = 5000;
my $rate_percentage = ($output_used / $rate_limit) * 100;

my $session_cost = $data->{cost}->{total_cost_usd} // 0;

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
    my $label       = sprintf("%d%%", $percentage);
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

my $token_bar = create_bar($used_percentage, $bar_width);
my $rate_bar = create_bar($rate_percentage, $bar_width);

my $cost_display = sprintf("\$%.2f", $session_cost);

print "Model: $model | Cost: $cost_display | Ctx: $token_bar | Rate: $rate_bar\n";
