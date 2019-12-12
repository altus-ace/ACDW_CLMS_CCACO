CREATE FUNCTION  [lst].[ValidateLstScoringSystem]
(   @Active INT,
    @EffDate DATE,
    @ExpDate DATE,
    @ClientKey INT,
    @LOB VARCHAR(20),
    @LOB_State CHAR(2),
    @ScoringType VARCHAR(20),
    @MeasureID VARCHAR(20),
    @MeasureDesc VARCHAR(100)
)
returns bit
as
begin
    declare @Valid bit = 1;

    IF(   SELECT COUNT(1)
	     FROM lst.lstScoringSystem s
	     WHERE s.Active = @Active
	       AND s.ClientKey = @ClientKey
	       AND s.LOB = @LOB
	       AND s.LOB_State = @LOB_State
	       AND @EffDate <= s.ExpirationDate and s.EffectiveDate <= @ExpDate
	       AND MeasureID = @MeasureID 
	       AND MeasureDesc = @MeasureDesc
	       AND ScoringType = @ScoringType			   
			   
			   )> 1
       set @Valid = 0;

    return @Valid;
end