import csv
import datetime

patient_info_dict = dict()

dim_age = "\n\n-- -----------------------------------------------------\n-- Insert `dim_age` entries\n-- -----------------------------------------------------\n"
dim_sex = "\n\n-- -----------------------------------------------------\n-- Insert `dim_sex` entries\n-- -----------------------------------------------------\n"
dim_infection_site = "\n\n-- -----------------------------------------------------\n-- Insert `dim_infection_site` entries\n-- -----------------------------------------------------\n"
dim_origin_country = "\n\n-- -----------------------------------------------------\n-- Insert `dim_origin_country` entries\n-- -----------------------------------------------------\n"
dim_symptomatology = "\n\n-- -----------------------------------------------------\n-- Insert `dim_symptomatology` entries\n-- -----------------------------------------------------\n"
dim_case_state = "\n\n-- -----------------------------------------------------\n-- Insert `dim_case_state` entries\n-- -----------------------------------------------------\n"
dim_case_info = "\n\n-- -----------------------------------------------------\n-- Insert `dim_case_info` entries\n-- -----------------------------------------------------\n"
facts_patient_info = "\n\n-- -----------------------------------------------------\n-- Insert `facts_patient_info` entries\n-- -----------------------------------------------------\n"


def get_day_range(start_date, end_date):
    try:
        start_date = datetime.datetime.strptime(start_date, "%d/%m/%y")
        end_date = datetime.datetime.strptime(end_date, "%d/%m/%y")
        return (end_date - start_date).days
    except ValueError:
        return "NULL"


def read_csv_to_list(file_name):
    with open(file_name) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=";")

        # skip first line
        next(csv_reader)

        return [row for row in csv_reader]


def init_facts_patient_info(rows):
    patients = [row[0] for row in rows]

    for patient_id in patients:
        patient_info_dict[patient_id] = [None] * 7


def insert_dim_age(rows):
    global dim_age

    ages = set([row[2] for row in rows])

    for idx, age in enumerate(ages):
        for row in rows:
            if row[2] == age:
                patient_info_dict[row[0]][0] = idx + 1

        if age != "":
            dim_age += "insert into dim_age (age_range) values ('{}');\n".format(age)
        else:
            dim_age += "insert into dim_age values ();\n"


def insert_dim_sex(rows):
    global dim_sex

    sex_types = set([row[1] for row in rows])

    for idx, sex in enumerate(sex_types):
        for row in rows:
            if row[1] == sex:
                patient_info_dict[row[0]][1] = idx + 1

        if sex != "":
            dim_sex += "insert into dim_sex (sex) values ('{}');\n".format(sex)
        else:
            dim_sex += "insert into dim_sex values ();\n"


def insert_dim_infection_site(rows):
    global dim_infection_site

    infection_site_values = set([(row[4], row[5]) for row in rows])

    for idx, val in enumerate(infection_site_values):
        province, city = val

        for row in rows:
            if (row[4], row[5]) == (province, city):
                patient_info_dict[row[0]][2] = idx + 1

        if province in ("", "etc"):
            province = "N/A"

        if city in ("", "etc"):
            city = "N/A"

        dim_infection_site += "insert into dim_infection_site (province, city) values ('{}', '{}');\n".format(
            province, city
        )


def insert_dim_origin_country(rows):
    global dim_origin_country

    origin_countries = set([row[3] for row in rows])

    for idx, country in enumerate(origin_countries):
        for row in rows:
            if row[3] == country:
                patient_info_dict[row[0]][3] = idx + 1

        dim_origin_country += (
            "insert into dim_origin_country (country) values ('{}');\n".format(country)
        )


def insert_dim_symptomatology(rows):
    global dim_symptomatology

    symptomatology_values = set([(row[9], row[10], row[11]) for row in rows])

    for idx, val in enumerate(symptomatology_values):
        start, confirmed, released = val

        for row in rows:
            if (row[9], row[10], row[11]) == (start, confirmed, released):
                patient_info_dict[row[0]][4] = idx + 1

        if start == "":
            start = "NULL"

        if confirmed == "":
            confirmed = "NULL"

        if released == "":
            released = "NULL"

        total_range = get_day_range(start, released)
        confirmed_range = get_day_range(confirmed, released)

        dim_symptomatology += "insert into dim_symptomatology (total_duration, recover_after_confirm) values ({}, {});\n".format(
            total_range, confirmed_range
        )


def insert_dim_case_state(rows):
    global dim_case_state

    case_state_values = set([row[13] for row in rows])

    for idx, state in enumerate(case_state_values):
        for row in rows:
            if row[13] == state:
                patient_info_dict[row[0]][5] = idx + 1

        if state != "":
            dim_case_state += (
                "insert into dim_case_state (state) values ('{}');\n".format(state)
            )
        else:
            dim_case_state += "insert into dim_case_state values ();\n"


def insert_dim_case_info(rows):
    global dim_case_info

    case_info_values = set([(row[6], row[7], row[8]) for row in rows])

    for idx, val in enumerate(case_info_values):
        infection_case, infected_by, number_of_contacts = val

        for row in rows:
            if (row[6], row[7], row[8]) == (
                infection_case,
                infected_by,
                number_of_contacts,
            ):
                patient_info_dict[row[0]][6] = idx + 1

        if infection_case in ("", "etc"):
            infection_case = "N/A"

        if infected_by == "":
            infected_by = "NULL"

        if number_of_contacts == "":
            number_of_contacts = "NULL"

        dim_case_info += 'insert into dim_case_info (infection_case, infected_by, number_of_contacts) values ("{}", {}, {});\n'.format(
            infection_case, infected_by, number_of_contacts
        )


def insert_facts_patient_info():
    global facts_patient_info

    for key, value in patient_info_dict.items():
        facts_patient_info += "insert into facts_patient_info (id, id_dim_age, id_dim_sex, id_dim_infection_site, id_dim_origin_country, id_dim_symptomatology, id_dim_case_state, id_dim_case_info) values ({}, {}, {}, {}, {}, {}, {}, {});\n".format(
            key, value[0], value[1], value[2], value[3], value[4], value[5], value[6]
        )


def main():
    csv_rows = read_csv_to_list("South_Korea_Covid19.csv")

    init_facts_patient_info(csv_rows)

    insert_dim_age(csv_rows)
    insert_dim_sex(csv_rows)
    insert_dim_infection_site(csv_rows)
    insert_dim_origin_country(csv_rows)
    insert_dim_symptomatology(csv_rows)
    insert_dim_case_state(csv_rows)
    insert_dim_case_info(csv_rows)

    insert_facts_patient_info()

    with open("populate_sript.sql", "w") as script_file:
        script_file.write("use covid_korea;")
        script_file.write(dim_age)
        script_file.write(dim_sex)
        script_file.write(dim_infection_site)
        script_file.write(dim_origin_country)
        script_file.write(dim_symptomatology)
        script_file.write(dim_case_state)
        script_file.write(dim_case_info)
        script_file.write(facts_patient_info)


if __name__ == "__main__":
    main()
