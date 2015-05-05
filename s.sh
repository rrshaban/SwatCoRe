read -p "Enter file name: " fname
read -p "Enter the search pattern: " pattern

result=$(grep -nr --exclude-dir="\./[log|tmp]" "$pattern" $fname)
echo "$result"