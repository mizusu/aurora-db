-- Create a temporary table to store the IDs to keep when trimming the Temperaturesensor table
CREATE TABLE KeepIds AS
SELECT MIN(Id) AS Id
FROM Temperaturesensor
GROUP BY YEAR(CaptureDate),
         MONTH(CaptureDate),
         DAY(CaptureDate),
         HOUR(CaptureDate),
         MINUTE(CaptureDate);

CREATE INDEX idx_keep_id ON KeepIds(Id);

