import requests
import json

BASE_URL = 'http://127.0.0.1:5000'

def print_response(response):
    print(f"Status Code: {response.status_code}")
    try:
        print(json.dumps(response.json(), indent=2))
    except ValueError:
        print(response.text)

def run_tests():
    print("GET all students:")
    response = requests.get(f"{BASE_URL}/students")
    print_response(response)

    print("\nPOST new student:")
    new_students = [
        {'first_name': 'John', 'last_name': 'Doe', 'age': 20},
        {'first_name': 'Jane', 'last_name': 'Smith', 'age': 22},
        {'first_name': 'Jim', 'last_name': 'Beam', 'age': 23}
    ]
    for student in new_students:
        response = requests.post(f"{BASE_URL}/students", json=student)
        print_response(response)

    print("\nGET all students:")
    response = requests.get(f"{BASE_URL}/students")
    print_response(response)

    print("\nPATCH student age (ID 2):")
    response = requests.patch(f"{BASE_URL}/students/2", json={'age': 23})
    print_response(response)
    
    print("\nGET student by ID 2:")
    response = requests.get(f"{BASE_URL}/students/2")
    print_response(response)

    print("\nPUT update student (ID 3):")
    updated_student = {'first_name': 'Jimmy', 'last_name': 'Beam', 'age': 24}
    response = requests.put(f"{BASE_URL}/students/3", json=updated_student)
    print_response(response)

    print("\nGET student by ID 3:")
    response = requests.get(f"{BASE_URL}/students/3")
    print_response(response)

    print("\nGET all students:")
    response = requests.get(f"{BASE_URL}/students")
    print_response(response)

    print("\nDELETE student by ID 1:")
    response = requests.delete(f"{BASE_URL}/students/1")
    print_response(response)

    print("\nGET all students:")
    response = requests.get(f"{BASE_URL}/students")
    print_response(response)

    with open('results.txt', 'w') as file:
        file.write("Results of API interactions:\n")

        def file_write_response(res):
            file.write(f"Status Code: {res.status_code}\n")
            try:
                file.write(json.dumps(res.json(), indent=2))
            except ValueError:
                file.write(res.text)
            file.write("\n\n")

        file_write_response(response)

if __name__ == "__main__":
    run_tests()