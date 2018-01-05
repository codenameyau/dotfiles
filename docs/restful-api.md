## RESTful APIs
https://en.wikipedia.org/wiki/Representational_state_transfer

## Resource examples
```
- School (one-to-many with class, many-to-many with teacher, one-to-one with principal)
- Classroom (one-to-one with school, one-to-many with class)
- Class (many-to-one with school, many-to-many with teacher)
- Teacher (many-to-many with school, many-to-many with class)
- Principal (one-to-one with school)
```

## General Principles

- **Client-Server Separation**: The API acts as a proxy for any clients to communicate indirectly with a database. That way the client does not need to care about the database, and the database will be protected and monitored by the API server(s).
- **Stateless**: Performing the same operation should not be affected by previous events nor rely on states and sessions.
- **Idempotency**: GET, PUT, and DEL are idempotent meaning the same operation should always result in the same outcome. POST is not idempotent, e.g. posting the same comment twice results in two new rows.

## HTTP CRUD Operations and Resources

#### List Resource

Supports GET and POST. Resources should be singular.

```bash
# List Resource Example: /school
#
# GET should always return a list.
# The API should be able to accept query string filters.

GET /school
GET /school?id=1
GET /school?id=1&id=2
GET /school?name=HighSchool
GET /school?id=1&name=HighSchool

# POST can accept a single object or a list of objects.
POST /school
```

#### Object Resource

Supports GET, PUT, DEL. Resources should be singular.

```bash
# Object Resource Example: /school/1
# Endpoint represents a specific school with the id of 1.
#
# Each endpoint accepts a single param (id) after the slash.
# Returns the id and http status code.

GET /school/1
PUT /school/1
DEL /school/1
```

## Entity Relation Representation
This is how the three entity relationships (1-1, 1-m, m-m) should be represented
in the URL resource.

- For 1-1 relationships, you do not need a separate table; add fk on both tables.
- For 1-m relationships, you do not need a separate table; add fk on the many table.
- For m-m relationships, you need a separate table with fk to both tables.

```bash
# One to one (1-1) means no nesting.
GET /school/1
GET /principal/1

------------------------------------------------------------------

# Many to many (m-m) means separate resource representation.
GET /classroom-to-teacher

------------------------------------------------------------------

# One to many (1-m) means nesting.
GET /school/1/classroom

# Be careful: the following two endpoints have a distinction for `/class`

# 1. This means get all the classes for this school.
GET /school/1/class

# 2. This means get all the classes for this classroom.
GET /school/1/classroom/1/class

# Nesting resources makes API code slimmer, less buggy, easier to work with and extend.
# Query strings should ONLY apply to the resource, i.e. school.
GET /school?classroom=1&class=1  # AVOID. It is very anti-restful.
```

## Common Practices

In the real world, most developers just return everything related to the resource. For example: in `/school/1`, the API returns the school's classrooms and classes. It's clean and saves API calls. It's your judgment to include what's necessary.
```
GET /school/1
```

```json
{
  "id": "1",
  "name": "Hogwarts",
  "classroom": [
    {
      "id": "1",
      "name": "Great Hall",
      "class": [
        {
          "id": "1",
          "name": "Intro to Sorting",
          "teacher_id": "1"
        }
      ]
    }
  ]
}
```
