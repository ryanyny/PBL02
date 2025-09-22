const Student = require('../models/studentModel')

exports.getAllStudents = async (req, res) => {
    try {
        const students = await Student.getAll()
        res.json(students)
    } catch (err) {
        res.status(500).json({ error: err.message })
    }
}