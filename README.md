# Чтение и запись в разные виды памяти

## Писать в CSR:
- i_csr_write_enable присваиваем "1"
- выставляем на i_rs1, i_rs2, i_rd, i_csr_array данные, которые хотим записать
- по фронту i_clk данные будут записаны

## Читать из CSR:
- данные из i_rs1, i_rs2, i_rd, csr_array и счетчика команд доступны всегда (o_rs1, o_rs2, o_rd, o_csr_array, o_prog_cnt соответственно)

## Писать в память данных:
- i_write_enable присваиваем "1"
- на i_write_addr выставляем адрес, куда хотим писать
- на i_write_data выставляем данные, которые хотим записать
- по фронту i_clk данные будут записаны

## Читать из памяти данных:
- i_write_enable присваиваем "0"
- на i_read_addr1 (i_read_addr2) выставляем адрес, из которого будем читать
- по фронту i_clk данные будут доступны на o_read_data1 (o_read_data2)

## Читать из памяти инструкций:
- на i_read_addr выставляем адрес, из которого будем читать
- по фронту i_clk данные будут доступны на o_read_data
