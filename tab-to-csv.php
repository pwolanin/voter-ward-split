#!/usr/bin/env php
<?php
/**
 * A simple CLI script to transform tab-delimited input
 * on stdin to csv output on stdout
 */

// Don't wait for input if there is none already.
//stream_set_blocking(STDIN, 0);

while (($line = fgets(STDIN)) !== FALSE) {
  $line = rtrim($line, "\r\n");
  // str_getcsv() gets confused by some voter rows with a call like "\",
  // even though it's useful to have it handle cells with quote characters.
  // By using explode(), we have to trust that there is not a tab
  // character inside double quotes.
  // $parts = str_getcsv($line, "\t");
  $parts = [];
  foreach(explode("\t", $line) as $cell) {
    $parts[] = trim($cell, '"');
  }
  fputcsv(STDOUT, $parts);
}

