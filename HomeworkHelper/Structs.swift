import Foundation
import SQLite3

struct Class {
    var id: Int32
    var name: String
}

struct Assignment {
    var id: Int32
    var name: String
    var subject: String
    var description: String
    var dueDate: String
}
class ClassManager {
    var database: OpaquePointer?
    
    static let shared = ClassManager()
    
    private init() {
    }
    
    func connect() {
        if database != nil {
            return
        }
        
        let databaseURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("Classes.sqlite")
        
        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        if sqlite3_exec(
            database,
            """
            CREATE TABLE IF NOT EXISTS classes (
                name TEXT
            )
            """,
            nil,
            nil,
            nil
        ) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    
    func create() -> Int {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO classes (name) VALUES ('New Class')",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting class")
            }
        }
        else {
            print("Error creating class insert statement")
        }
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getClasses() -> [Class] {
        connect()
        
        var result: [Class] = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT rowid, name FROM classes", -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                result.append(Class(
                    id: sqlite3_column_int(statement, 0),
                    name: String(cString: sqlite3_column_text(statement, 1))
                )
                )
            }
        }
        
        sqlite3_finalize(statement)
        return result
    }
    
    func saveClass(subject: Class) {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "UPDATE classes SET name = ? WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: subject.name).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, subject.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving class")
            }
        }
        else {
            print("Error creating note update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteClass(subject: Class) {
        connect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "DELETE FROM classes WHERE name = ? AND rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: subject.name).utf8String, -1, nil)
            sqlite3_bind_int(statement, 2, subject.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting Class")
            }
        }
        else {
            print("Error creating class deletion statement")
        }
        
        sqlite3_finalize(statement)
    }
}




class AssignmentManager {
    var database: OpaquePointer?
    
    static let shared = AssignmentManager()
    
    private init() {
    }
    
    func Aconnect() {
        if database != nil {
            return
        }
        
        let databaseURL = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        ).appendingPathComponent("Assignments.sqlite")
        
        if sqlite3_open(databaseURL.path, &database) != SQLITE_OK {
            print("Error opening database")
            return
        }
        
        if sqlite3_exec(
            database,
            """
            CREATE TABLE IF NOT EXISTS assignments (
                name TEXT,
                subject TEXT,
                description TEXT,
                duedate TEXT
            )
            """,
            nil,
            nil,
            nil
        ) != SQLITE_OK {
            print("Error creating table: \(String(cString: sqlite3_errmsg(database)!))")
        }
    }
    
    func Acreate(subject: Class) -> Int {
        Aconnect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "INSERT INTO assignments (name, subject, description, dueDate) VALUES ('New Assignment', ?, 'Insert Description Here', 'Due Date: ')",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            let name: NSString = subject.name as NSString
            sqlite3_bind_text(statement, 1, name.utf8String, -1, nil)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error inserting assignment")
            }
        }
        else {
            print("Error creating assignment insert statement")
        }
        sqlite3_finalize(statement)
        return Int(sqlite3_last_insert_rowid(database))
    }
    
    func getAssignments(subject: Class) -> [Assignment] {
        Aconnect()
    
        let name: NSString = subject.name as NSString
        var result: [Assignment] = []
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(database, "SELECT rowid, name, subject, description, dueDate FROM assignments WHERE subject = ?", -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, name.utf8String, -1, nil)
            while sqlite3_step(statement) == SQLITE_ROW {
                result.append(Assignment(
                    id: sqlite3_column_int(statement, 0),
                    name: String(cString: sqlite3_column_text(statement, 1)),
                    subject: String(cString: sqlite3_column_text(statement, 2)),
                    description: String(cString: sqlite3_column_text(statement, 3)),
                    dueDate: String(cString: sqlite3_column_text(statement, 4))
                )
                )
            }
        }

        sqlite3_finalize(statement)
        return result
    }
    
    func saveAssignment(subject: Assignment) {
        Aconnect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "UPDATE assignments SET name = ?, description = ?, dueDate = ? WHERE rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: subject.name).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, NSString(string: subject.description).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, NSString(string: subject.dueDate).utf8String, -1, nil)
            sqlite3_bind_int(statement, 4, subject.id)
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error saving assignment")
            }
        }
        else {
            print("Error creating assignment update statement")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteAssignment(subject: Assignment) {
        Aconnect()
        
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(
            database,
            "DELETE FROM assignments WHERE name = ? AND subject = ? AND description = ? AND duedate = ? AND rowid = ?",
            -1,
            &statement,
            nil
        ) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, NSString(string: subject.name).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, NSString(string: subject.subject).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, NSString(string: subject.description).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, NSString(string: subject.dueDate).utf8String, -1, nil)
            sqlite3_bind_int(statement, 5, subject.id)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Error deleting Assignment")
            }
        }
        else {
            print("Error creating assignment deletion statement")
        }
        
        sqlite3_finalize(statement)
    }
}

