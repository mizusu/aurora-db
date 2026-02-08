SELECT CONCAT('=== Trimming run started at ', NOW(), ' ===') AS Info;

SELECT CONCAT(NOW(), '(Step 1) Creating KeepIds table...') AS Info;

SET @cutoff := NOW() - INTERVAL 5 MINUTE;
SELECT CONCAT('Cutoff time: ', @cutoff) AS Info;

CREATE TEMPORARY TABLE KeepIds AS
SELECT MIN(Id) AS Id
FROM temperaturesensor
WHERE CaptureDate < @cutoff
GROUP BY DATE_FORMAT(CaptureDate, '%Y-%m-%d %H:%i');

CREATE INDEX idx_keep_id ON KeepIds(Id);

SELECT CONCAT(NOW(), ': KeepIds table created') AS Info;

SELECT CONCAT(NOW(), ': (Step 2) Batch deleting old records...') AS Info;

DELIMITER $$

DROP PROCEDURE IF EXISTS trim_loop $$

CREATE PROCEDURE trim_loop()
BEGIN
    DECLARE rows_deleted INT DEFAULT 1;
    DECLARE total_deleted BIGINT DEFAULT 0;

    WHILE rows_deleted > 0 DO

        DELETE FROM temperaturesensor
        WHERE Id IN (
            SELECT Id FROM (
                SELECT t.Id
                FROM temperaturesensor t
                LEFT JOIN KeepIds k ON t.Id = k.Id
                WHERE k.Id IS NULL
                  AND t.CaptureDate < @cutoff
                LIMIT 10000
            ) AS batch
        );

        SET rows_deleted = ROW_COUNT();
        SET total_deleted = total_deleted + rows_deleted;

        SELECT CONCAT(
            NOW(),
            ' | Batch deleted: ',
            rows_deleted,
            ' | Total deleted: ',
            total_deleted
        ) AS Info;

    END WHILE;

    SELECT CONCAT(
        NOW(),
        ' | Finished. Total deleted: ',
        total_deleted
    ) AS Info;
END $$

DELIMITER ;

CALL trim_loop();

DROP PROCEDURE trim_loop;

SELECT CONCAT(NOW(), ': (Step 3) Dropping temporary tables...') AS Info;

DROP TEMPORARY TABLE IF EXISTS KeepIds;

SELECT CONCAT('Trimming complete at ', NOW()) AS Info;
