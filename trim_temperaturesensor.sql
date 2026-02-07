-- trim_temperaturesensor.sql

SELECT 'Step 1: Creating KeepIds table...' AS Info;

CREATE TEMPORARY TABLE IF NOT EXISTS KeepIds AS
SELECT MIN(Id) AS Id
FROM Temperaturesensor
GROUP BY YEAR(CaptureDate),
         MONTH(CaptureDate),
         DAY(CaptureDate),
         HOUR(CaptureDate),
         MINUTE(CaptureDate);

CREATE INDEX IF NOT EXISTS idx_keep_id ON KeepIds(Id);

SELECT 'Step 2: Deleting old records...' AS Info;

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

SELECT 'Step 3: Dropping KeepIds table...' AS Info;

DROP TABLE IF EXISTS KeepIds;

SELECT 'Trimming complete.' AS Info;
