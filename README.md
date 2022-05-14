# Assembler


## Task0
Разработка низкоуровневой системной утилиты для работы с системными структурами физических и логических дисков, объектами файловой системы.
Индивидуальное задание: Создание расширенного раздела и двух логических дисков в нем.


## Task1
В сегменте данных размещены числа 1,2,-3,288,+128 и символьная строка ‘abc’. Из двухбайтных кодов взять старшие байты и записать их после исходных данных. Следом записать нулевое слово и исходную символьную строку в обратной послдовательности.
### Segments
- data segment ***dseg*** (segment pointer ds) 
- code segment ***cseg*** (segment pointer cs)
### Data in memory, symbolic addresses  
In the input data segment ***dseg***:
1. a – адрес последовательной записи 5-ти заданных двухбайтных чисел
1. b – адрес последовательной записи заданной символьной строки из 3-х символов
1. с – адрес выделенной памяти 10 байт для записи
### Use of registers
1. аl - to forward 


## Task2
Определить чатсное от division numb1 на младший байт numb2. Определить произведение numb1 и numb2. В полученном произведении поменять местами пары значений битов: 2-1 и 7-6 и инвертировать 4 бит.
### Segments
- data segment ***dseg*** (segment pointer ds) 
- code segment ***cseg*** (segment pointer cs)
### Data in memory, symbolic addresses  
In the input data segment ***dseg***:
1. a – симовлический адресс однобайтного numb1.
1. b – симовлический адресс двухбайтного numb2.
1. c – симовлический адресс выделенной памяти в один байт под запись частного от division numb1 на младший байт numb2
1. d – симовлический адресс выделенной памяти в два байта под запись произведение numb1 и numb2.
### Use of registers
1. ax – to forward and extension
1. bl – to forward, division, shift, logical OR, logical AND
1. bh – to forward, shift, logical OR
1. al – to forward, logical OR, exclusive OR
1. bx – to forward, multiplication


## Task3
![image](https://user-images.githubusercontent.com/43647354/168090741-6738c02f-857e-48cc-b84d-50fbef0b9258.png)
### Segments
- data segment ***dseg*** (segment pointer ds) 
- code segment ***cseg*** (segment pointer cs)
### Data in memory, symbolic addresses  
In the input data segment ***dseg***
1. x – симовлический адресс однобайтной знаковой величины.
1. y – симовлический адресс двухбайтного результата.
### Use of registers
1. ax – to forward and extension
1. bx – to forward, adding and subtracting 


## Task4
Область кодового сегмента содержит двухбайтные знаковые числа. Определить наименьшее из отрицательных чисел. Если это значение больше -30, то записать его в память в формате двойного слова.
### Segments
- code segment ***cseg*** (segment pointer cs)
### Data in memory, symbolic addresses  
In the input data segment ***cseg***
1. а – символический адресс массива из 5 двухбайтных знаковых величин.
1. b – символический адресс четырехбайтного результата.
### Use of registers
1. ax – to forward и записи минимального значения
1. bx – to forward, сравнения 
1. si – адрес элемента массива
1. сх – счетчик для цикла loop


## Task5
Область кодового сегмента содержит двухбайтные знаковые числа. Определить наименьшее из отрицательных чисел. Если это значение больше -30, то записать его в память в формате двойного слова. Использовать процедуру для создания нового массива из отрицательных чисел произвольного массива двухбайтных чисел. Входные параметры: адрес начала исходного массива, количесвто чисел в исходном массиве, адрес нового массива.
### Segments
- first code segment ***code1*** (segment pointer cs)
- second code segment ***code2*** (segment pointer cs)
### Data in memory, symbolic addresses  
In the input data segment ***cseg***
1. а – символический адресс массива из 5 двухбайтных знаковых величин.
1. b – символический адресс четырехбайтного результата.
1. с – символический адресс массива из отрицательных чисел произвольного массива двухбайтных чисел.
### Use of registers
1. ax – to forward и записи минимального значения
1. bx – to forward, сравнения 
1. dx – to forward
1. si – адрес элемента исходного массива
1. di – адрес элемента нового массива
1. сх – счетчик для цикла loop
