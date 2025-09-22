const pool = require('../database')

module.exports = {
    getAll: async () => {
        const [rows] = await pool.query('SELECT * FROM students')
        return rows
    }
}