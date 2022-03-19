#there are two types of loops
#1. loops based on expression while loop
#2. loops based on inputs for loop
i=10
while [ $i -gt 0 ]
do
  echo iteration = "${i}"
  i=$(("${i}"-1))
done
for size in shoes shirt pant
do
  echo size 42 in ${size}
done
