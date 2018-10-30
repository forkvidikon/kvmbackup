#! /bin/bash

# Подключение библиотек
. ./lib/basic.so
. ./lib/vmachine.so


function main {
    #Вызов функции создания дампа
    if [[ $config_dump = "yes" ]]
        then
            # Вызов функции
            dumpconfig
            error_handler 0 0 "Дамп конфигурации виртуальной машины $vmachine_name сохранен в $config_patch "
   fi

    # Вызов функции полного копирования виртуального диска
    if [[ $disk_full_copy = "yes" ]]
        then
            # Вызов функций
            vmachine_shutdown
            fulldiskcopy
            vmachine_start
            error_handler 0 0  "Диск виртуальной машины $vmachine_name скопирован в $disk_output_file_path"
            
    fi

    if [[ $snapshot_create_snapshot = "yes" ]]
        then 
            create_snapshot
            error_handler 0 0 "Создан снимок виртуальной машины $vmachine_name. Имя снимка $snapshot_name"
    fi
    return 10
}

check_configuration $1

error_handler 0 0 "Начат процесс резервного копирования виртуальной машины $vmachine_name. Процесс начат в $MOMENT"

main
    if [[ $? -eq 10 ]]
        then 
            error_handler 0 0 "Резервное копирование завершено. На часах $MOMENT"
    fi

