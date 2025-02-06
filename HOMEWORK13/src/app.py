from flask import Flask, jsonify, request, abort
import csv
import os

app = Flask(__name__)

STUDENTS_FILE = 'students.csv'

if not os.path.isfile(STUDENTS_FILE):
    with open(STUDENTS_FILE, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['id', 'first_name', 'last_name', 'age'])

def read_students():
    with open(STUDENTS_FILE, newline='') as file:
        reader = csv.DictReader(file)
        return list(reader)

def write_students(students):
    with open(STUDENTS_FILE, 'w', newline='') as file:
        fieldnames = ['id', 'first_name', 'last_name', 'age']
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(students)

@app.route('/students', methods=['GET'])
def get_all_students():
    students = read_students()
    return jsonify(students), 200

@app.route('/students/<int:id>', methods=['GET'])
def get_student_by_id(id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == id), None)
    if not student:
        abort(404, description="Student not found")
    return jsonify(student), 200

@app.route('/students/lastname/<string:last_name>', methods=['GET'])
def get_students_by_last_name(last_name):
    students = read_students()
    matched_students = [s for s in students if s['last_name'] == last_name]
    if not matched_students:
        abort(404, description="Student not found")
    return jsonify(matched_students), 200

@app.route('/students', methods=['POST'])
def create_student():
    if not request.json or not all(k in request.json for k in ('first_name', 'last_name', 'age')):
       abort(400, description="Missing fields")
    students = read_students()
    new_id = max([int(s['id']) for s in students] or [0]) + 1
    new_student = {
        'id': new_id,
        'first_name': request.json['first_name'],
        'last_name': request.json['last_name'],
        'age': request.json['age']
    }
    students.append(new_student)
    write_students(students)
    return jsonify(new_student), 201

@app.route('/students/<int:id>', methods=['PUT'])
def update_student(id):
    if not request.json or not all(k in request.json for k in ('first_name', 'last_name', 'age')):
        abort(400, description="Missing fields")

    students = read_students()
    student = next((s for s in students if int(s['id']) == id), None)
    if not student:
        abort(404, description="Student not found")

    student.update({
        'first_name': request.json['first_name'],
        'last_name': request.json['last_name'],
        'age': request.json['age']
    })
    write_students(students)
    return jsonify(student), 200
@app.route('/students/<int:id>', methods=['PATCH'])
def patch_student(id):
    if not request.json or 'age' not in request.json:
        abort(400, description="Student not found")

    students = read_students()
    student = next((s for s in students if int(s['id']) == id), None)
    if not student:
        abort(404, description="Student not found")

    student['age'] = request.json['age']
    write_students(students)
    return jsonify(student), 200

@app.route('/students/<int:id>', methods=['DELETE'])
def delete_students(id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == id), None)
    if not student:
        abort(404, description="Student not found")

    students = [s for s in students if int(s['id']) != id]
    write_students(students)
    return jsonify({'message': 'Student successfully deleted'}), 200


if __name__ == '__main__':
    app.run(debug=True)