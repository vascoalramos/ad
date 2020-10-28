import csv

countryCodes = set()
countries = "\n\n-- -----------------------------------------------------\n-- Insert `country` entries\n-- -----------------------------------------------------\n"
day_stats = "\n\n-- -----------------------------------------------------\n-- Insert `dayStats` entries\n-- -----------------------------------------------------\n"
week_stats = "\n\n-- -----------------------------------------------------\n-- Insert `weekStats` entries\n-- -----------------------------------------------------\n"


def insert_country(row):
    global countries

    if row[7] not in countryCodes:
        countryCodes.add(row[7])
        countries += "insert into country (id, name, population) values ('{}', '{}', {});\n".format(
            row[7], row[6], row[8]
        )


def insert_day_stats(row):
    global day_stats

    day_stats += "insert into dayStats (day, countryId, weekNr, `#cases`, `#deaths`, `#cumulativePer100`) values ('{}', '{}', {}, {}, {}, {});\n".format(
        "{}-{}-{}".format(row[2], row[1], row[0]),
        row[7],
        row[3].split(" ")[1],
        row[4],
        row[5],
        row[9].replace(",", ""),
    )


def insert_week_stats(row):
    global week_stats

    week_stats += "insert into weekStats (countryId, weekNr, `#newCases`, `#testsDone`, testingRate, positivityRate) values ('{}', {}, {}, {}, {}, {});\n".format(
        row[1], row[2].split(" ")[1], row[3], row[4], row[6], row[7]
    )


def main():
    with open("COVID19_EU_EEA_UK_DATA.csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=";")

        count = 0

        for row in csv_reader:
            if count != 0:
                insert_country(row)
                insert_day_stats(row)

            count += 1

    with open("COVID19_EU_EEA_UK_TESTING.csv") as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=";")

        count = 0

        for row in csv_reader:
            if count != 0:
                insert_week_stats(row)

            count += 1

    with open("populate_sript.sql", "w") as script_file:
        script_file.write("use covid;")
        script_file.write(countries)
        script_file.write(day_stats)
        script_file.write(week_stats)


if __name__ == "__main__":
    main()
