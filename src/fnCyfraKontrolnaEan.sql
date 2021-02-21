SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnCyfraKontrolnaEan](@ean varchar(12))
RETURNS CHAR(1)
AS
BEGIN
    DECLARE
        @cyfra_controlna int,
        @chk int
    DECLARE @num TABLE(num int)
    IF    LEN(@ean) NOT IN (7, 12)
    BEGIN
        RETURN     NULL
    END

    INSERT INTO @num
        SELECT 1
    UNION ALL
        SELECT 2
    UNION ALL
        SELECT 3
    UNION ALL
        SELECT 4
    UNION ALL
        SELECT 5
    UNION ALL
        SELECT 6
    UNION ALL
        SELECT 7
    UNION ALL
        SELECT 8
    UNION ALL
        SELECT 9
    UNION ALL
        SELECT 10
    UNION ALL
        SELECT 11
    UNION ALL
        SELECT 12

    SELECT @cyfra_controlna = SUM(CONVERT(int, SUBSTRING(@ean, LEN(@ean) - num + 1, 1)) * CASE WHEN num % 2 = 1 THEN 3 ELSE 1 END)
        FROM @num
        WHERE num <= LEN(@ean)
    SELECT @cyfra_controlna = (10 - (@cyfra_controlna % 10)) % 10
    RETURN  CHAR(ASCII('0') + @cyfra_controlna)
END
GO
