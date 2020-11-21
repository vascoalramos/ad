import csv
import datetime

dim_category_values = dict()
dim_actor_values = dict()
dim_director_values = dict()
dim_country_values = dict()


def read_csv_to_list(file_name):
    with open(file_name) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=";")

        # skip first line
        next(csv_reader)

        return [row for row in csv_reader]


def insert_dim_category(rows):
    categories = set(
        [category.strip() for row in rows for category in row[10].split(",")]
    )

    with open("scripts/populate_categories.sql", "w") as script_file:
        script_file.write("use netflix;\n")
        script_file.write("\n-- populate dim_category\n")

        idx = 1
        for category in categories:
            if category != "":
                dim_category_values[category] = idx
                sql = 'insert into dim_category (id, category) values ({}, "{}");\n'.format(
                    idx, category
                )
                script_file.write(sql)
                idx += 1


def insert_mid_categories_listed_in(rows):
    with open("scripts/populate_categories.sql", "a") as script_file:
        script_file.write("\n-- populate mid_categories_listed_in\n")

        for row in rows:
            for category in row[10].split(","):
                if category != "":
                    category = category.strip()
                    category_id = dim_category_values[category]

                    sql = "insert into mid_categories_listed_in (id_show, id_category) values ({}, {});\n".format(
                        row[0], category_id
                    )
                    script_file.write(sql)


def insert_dim_actor(rows):
    actors = set([actor.strip() for row in rows for actor in row[4].split(",")])

    with open("scripts/populate_cast.sql", "w") as script_file:
        script_file.write("use netflix;\n")
        script_file.write("\n-- populate dim_actor\n")

        idx = 1
        for actor in actors:
            if actor != "":
                dim_actor_values[actor] = idx
                sql = 'insert into dim_actor (id, name) values ({}, "{}");\n'.format(
                    idx, actor
                )
                script_file.write(sql)
                idx += 1


def insert_mid_cast(rows):
    with open("scripts/populate_cast.sql", "a") as script_file:
        script_file.write("\n-- populate mid_cast\n")

        for row in rows:
            for actor in row[4].split(","):
                if actor != "":
                    actor = actor.strip()
                    actor_id = dim_actor_values[actor]
                    sql = "insert into mid_cast (id_show, id_actor) values ({}, {});\n".format(
                        row[0], actor_id
                    )
                    script_file.write(sql)


def insert_dim_director(rows):
    directors = set(
        [director.strip() for row in rows for director in row[3].split(",")]
    )

    with open("scripts/populate_directors.sql", "w") as script_file:
        script_file.write("use netflix;\n")
        script_file.write("\n-- populate dim_director\n")

        idx = 1
        for director in directors:
            if director != "":
                dim_director_values[director] = idx
                sql = 'insert into dim_director (id, name) values ({}, "{}");\n'.format(
                    idx, director
                )
                script_file.write(sql)
                idx += 1


def insert_mid_directors(rows):
    with open("scripts/populate_directors.sql", "a") as script_file:
        script_file.write("\n-- populate mid_directors\n")

        for row in rows:
            for director in row[3].split(","):
                if director != "":
                    director = director.strip()
                    director_id = dim_director_values[director]

                    sql = "insert into mid_directors (id_show, id_director) values ({}, {});\n".format(
                        row[0], director_id
                    )
                    script_file.write(sql)


def insert_dim_country(rows):
    countries = set([country.strip() for row in rows for country in row[5].split(",")])

    with open("scripts/populate_countries.sql", "w") as script_file:
        script_file.write("use netflix;\n")
        script_file.write("\n-- populate dim_country\n")

        idx = 1
        for country in countries:
            if country != "":
                dim_country_values[country] = idx
                sql = (
                    'insert into dim_country (id, country) values ({}, "{}");\n'.format(
                        idx, country
                    )
                )
                script_file.write(sql)
                idx += 1


def insert_mid_countries_filmed_in(rows):
    with open("scripts/populate_countries.sql", "a") as script_file:
        script_file.write("\n-- populate mid_countries_filmed_in\n")

        for row in rows:
            for country in row[5].split(","):
                if country != "":
                    country = country.strip()
                    country_id = dim_country_values[country]

                    sql = "insert into mid_countries_filmed_in (id_show, id_country) values ({}, {});\n".format(
                        row[0], country_id
                    )
                    script_file.write(sql)


def main():
    csv_rows = read_csv_to_list("netflix_dataset.csv")

    insert_dim_category(csv_rows)
    insert_mid_categories_listed_in(csv_rows)

    insert_dim_actor(csv_rows)
    insert_mid_cast(csv_rows)

    insert_dim_director(csv_rows)
    insert_mid_directors(csv_rows)

    insert_dim_country(csv_rows)
    insert_mid_countries_filmed_in(csv_rows)


if __name__ == "__main__":
    main()
