import re
from datetime import datetime
import sys


def parse_mql5_struct(file_path):
    print(file_path)
    # Обновленный паттерн для поиска комментариев перед полями
    struct_start_pattern = r'PARSING AREA OF INPUT STRUCTURE == START == DO NOT REMOVE THIS COMMENT([\s\S]*?)PARSING AREA OF INPUT STRUCTURE == END == DO NOT REMOVE THIS COMMENT'
    field_pattern = r'(\s*//\s*(input\s+group[\s\S]*?)\s*)?(\s*\w+\s+[\w:]+)\s*;\s*//\s*(.*)'

    with open(file_path, 'r', encoding='utf-16') as file:
        content = file.read()

    # Находим структуру между комментариями "// PARSED STRUCTURE" и "// USER INPUTS FINISH"
    struct_match = re.search(struct_start_pattern, content)
    if not struct_match:
        print("Структура не найдена между комментариями.")
        return {}, content

    # Извлекаем структуру
    struct_body = struct_match.group(1)  # Все содержимое между комментариями
    struct_name_match = re.search(r"struct\s+(\w+)", struct_body)
    if not struct_name_match:
        print("Имя структуры не найдено.")
        return {}, content

    struct_name = struct_name_match.group(1)

    # Извлекаем поля из структуры с комментариями
    fields = re.findall(field_pattern, struct_body)

    # Парсим поля и комментарии
    struct_dict = {struct_name: {}}
    current_group = ""
    for group_comment, _, field, comment in fields:
        field_type = field.split()[0].strip()  # Тип поля - первое слово в строке
        field_name = field.split()[-1]  # Имя поля - последнее слово в строке

        # Если комментарий связан с группой, сохраняем его как group
        if group_comment:
            current_group = group_comment.strip()
        else:
            current_group = ""  # Если не группа, сбрасываем

        # Разделяем комментарий на описание, дефолтное значение и условия
        comment_part, default_value, validation_conditions = "", "", ""
        if "//" in comment:
            comment_parts = comment.split("//", 2)
            comment_part = comment_parts[0].strip()

            if len(comment_parts) > 1:
                default_section = comment_parts[1].strip()
                if "(" in default_section and ")" in default_section:
                    # Извлекаем условия
                    match = re.search(r"\((.*)\)", default_section)
                    if match:
                        validation_conditions = match.group(1).replace("x", field_name)
                    default_value = default_section.split("(")[0].strip()
                else:
                    default_value = default_section
        else:
            comment_part = comment.strip()

        # Если дефолтное значение отсутствует, используем 0
        if not default_value:
            default_value = "0"

        # Добавляем информацию о поле в словарь
        struct_dict[struct_name][field_name] = {
            "type": field_type,
            "comment": comment_part,
            "default": default_value,
            "allowed_validation": validation_conditions,
            "group": current_group  # Добавляем группу
        }

    return struct_dict, content


def generate_field_declarations(parsed_dict):
    if not parsed_dict:
        return "", ""

    # Получаем имя структуры и её поля
    struct_name, fields = next(iter(parsed_dict.items()))

    # Формируем закомментированные строки с объявлениями
    declarations = []
    initialization_code = []

    # Переменная для отслеживания уже выведенных групп
    printed_groups = set()

    # Формируем строки с объявлениями полей
    for field, attributes in fields.items():
        field_type = attributes["type"]
        field_name = field
        default_value = attributes["default"]
        comment = attributes["comment"]
        group = attributes["group"]

        # Если группа не была выведена ранее, добавляем её
        if group and group not in printed_groups:
            declarations.append("\n" + group)
            printed_groups.add(group)

        # Формируем строку объявления с дефолтным значением и комментарием
        declarations.append(f"// input  {field_type:<25} Inp_{field_name:<30} = {default_value}; // {comment}")

        # Формируем строку инициализации с комментариями
        initialization_code.append(f"// inputs.{field_name:<25} = Inp_{field_name}; // {comment}")

    # Выравниваем комментарии
    max_length = max(len(line.split(" // ")[0]) for line in declarations if " // " in line)
    declarations_code = "\n".join(
        f"{line.split(' // ')[0]:<{max_length}} // {line.split(' // ')[1]}" if " // " in line else line
        for line in declarations)
    initialization_code = "\n".join(
        f"{line.split(' // ')[0]:<{max_length}} // {line.split(' // ')[1]}" if " // " in line else line
        for line in initialization_code)

    # Добавляем строку с именем структуры в начало итогового инициализационного кода
    initialization_code = f"\n// {struct_name} inputs;\n" + initialization_code

    return declarations_code, initialization_code


def generate_constructor_code(parsed_dict):
    if not parsed_dict:
        return ""

    # Получаем имя структуры и её поля
    struct_name, fields = next(iter(parsed_dict.items()))

    # Формируем список инициализаций
    initializations = []
    for field, attributes in fields.items():
        default_value = attributes["default"]
        if default_value != "0":  # Только для полей с дефолтным значением
            initializations.append(f"       {field}({default_value})")

    # Объединяем инициализации с разделением на строки
    init_code = ",\n".join(initializations)

    # Формируем финальный код конструктора
    constructor_code = f"""\n
//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+
void {struct_name}::{struct_name}():\n{init_code}{{\n\n}};"""
    return constructor_code


def generate_checkbeforeinit_code(parsed_dict):
    if not parsed_dict:
        return ""

    # Получаем имя структуры и её поля
    struct_name, fields = next(iter(parsed_dict.items()))

    # Формируем проверки для каждого поля
    checks = []
    for field, attributes in fields.items():
        validation = attributes["allowed_validation"]
        if validation:  # Проверяем только если есть условие
            validation_condition = validation.replace("&&", "&&").replace("||", "||")
            checks.append(
                f"  if(!({validation_condition})) "
                f"LastErrorMessage = \"'{field}' must satisfy condition: {validation}\";"
            )

    # Объединяем проверки в тело метода
    checks_code = "\n".join(checks)

    # Формируем финальный код метода
    check_method_code = f"""\n
//+------------------------------------------------------------------+
//| Check struc before Init
//+------------------------------------------------------------------+
bool {struct_name}::CheckBeforeInit() {{
  LastErrorMessage = "";
{checks_code}

  return LastErrorMessage == "";
}}"""
    return check_method_code


def update_file_with_generated_code(file_path, parsed_dict, constructor_code, checkbeforeinit_code, declarations_code, initialization_code):
    with open(file_path, 'r', encoding='utf-16') as file:
        content = file.read()

    # Определяем секцию для вставки
    generated_section_pattern = r'// GENERATED CODE == START == DO NOT REMOVE THIS COMMENT[\s\S]*?// GENERATED CODE == END == DO NOT REMOVE THIS COMMENT'
    generated_code = f"""// GENERATED CODE == START == DO NOT REMOVE THIS COMMENT
{declarations_code}
{initialization_code}
{constructor_code}
{checkbeforeinit_code}
// GENERATED CODE == END == DO NOT REMOVE THIS COMMENT"""

    # Заменяем или добавляем секцию
    if re.search(generated_section_pattern, content):
        content = re.sub(generated_section_pattern, generated_code, content)
    else:
        content += f"\n\n{generated_code}"

    # Сохраняем файл с добавлением datetime в имя
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    new_file_path = f"{file_path.rsplit('.', 1)[0]}_{timestamp}.mqh"
    new_file_path = file_path

    with open(new_file_path, 'w', encoding='utf-16') as new_file:
        new_file.write(content)

    return new_file_path


# Основной скрипт
file_path = sys.argv[1]

# Парсим структуру
parsed_dict, original_content = parse_mql5_struct(file_path)

# Генерируем код
constructor_code = generate_constructor_code(parsed_dict)
checkbeforeinit_code = generate_checkbeforeinit_code(parsed_dict)
declarations_code, initialization_code = generate_field_declarations(parsed_dict)

# Обновляем файл
updated_file_path = update_file_with_generated_code(
    file_path, parsed_dict, constructor_code, checkbeforeinit_code, declarations_code, initialization_code)

print(f"Файл обновлён и сохранён как: {updated_file_path}")
