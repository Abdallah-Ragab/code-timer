#!/bin/bash
input="art.txt"
while IFS= read -r line
do
  echo "$line"
done < "$input"