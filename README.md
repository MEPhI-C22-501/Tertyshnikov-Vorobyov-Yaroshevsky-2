# Чтение и запись в разные виды памяти

## Писать в счетчик команд:
- в разрешающий сигнал (i_program_counter_write_enable) присваиваем "1"
- выставляем на i_program_counter данные, которые хотим записать
- по фронту i_clk данные будут записаны

## Писать в RegisterFile:
- в разрешающий сигнал (i_registers_write_enable) присваиваем "1"
- выставляем на i_registers_array данные, которые хотим записать
- выставляем на i_registers_number номер регистра, в который хотим записать данные
- по фронту i_clk данные будут записаны

## Читать из RegisterFile:
- данные из registers_array и счетчика команд доступны всегда (o_registers_array, o_program_counter соответственно)
- самый первый регистр в o_registers_array всегда возвращает "0"
- на каждом фронте тактового сигнала значение o_program_counter увеличивается на 1

## Писать в память данных:
- i_write_enable присваиваем "1"
- на i_addr выставляем адрес, куда хотим писать
- на i_write_data выставляем данные, которые хотим записать
- по фронту i_clk данные будут записаны

## Читать из памяти данных:
- i_write_enable присваиваем "0"
- на i_addr выставляем адрес, из которого будем читать
- по фронту i_clk данные будут доступны на o_read_data

## Читать из InstructionMemory:
- на i_read_addr выставляем адрес, из которого будем читать
- по фронту i_clk данные будут доступны на o_read_data

## Читать из CSR:
- на i_addr выставляем адрес, из которого будем читать
- по фронту i_clk данные будут доступны на o_data
