
-- This SQL script deletes records from the Temperaturesensor table based on a list of IDs that are not present in the KeepIds table.
-- It processes the deletions in batches of 10,000 to manage performance and avoid locking issues.
DELETE FROM Temperaturesensor
WHERE Id IN (
    SELECT Id
    FROM (
        SELECT t.Id
        FROM Temperaturesensor t
        LEFT JOIN KeepIds k ON t.Id = k.Id
        WHERE k.Id IS NULL
        LIMIT 10000
    ) AS batch
);
