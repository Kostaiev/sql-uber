-- Task: Find the shortest route between two intersections.
-- Constraints:
--   - The route must cross exactly one specified river bridge.
--   - Bridge IDs are provided as parameters.
--   - Road segments are treated as undirected edges.
--
-- Note: Search is limited to 5 road segments.

SET @start = 1;
SET @finish = 5;

SET @bridge1 = 3;
SET @bridge2 = 4;

WITH RECURSIVE shortestPath AS(
	SELECT 0 AS hops,
        @start AS current_cross,
        CAST(',' AS CHAR(100)) AS used_segments,
        0 AS total_m,
        CAST(CONCAT(',', @start, ',') AS CHAR(100)) AS visited,
        0 AS bridge_count
   
    
    UNION ALL
    
    SELECT 
        s.hops + 1, 
        CASE
            WHEN s.current_cross = rs.cross1_id THEN rs.cross2_id
            ELSE rs.cross1_id
        END AS current_cross,
        CONCAT(s.used_segments, rs.id,',') AS used_segments,
        s.total_m + rs.distance_m AS total_m,
        CONCAT(s.visited, 
                CASE
                    WHEN s.current_cross = rs.cross1_id THEN rs.cross2_id
                    ELSE rs.cross1_id
                END,
            ',') AS visited,
        CASE 
            WHEN rs.id IN(@bridge1, @bridge2) THEN s.bridge_count + 1
            ELSE s.bridge_count
        END AS bridge_count
    FROM shortestPath AS s
    JOIN `road_segment` AS rs
    ON s.current_cross IN(rs.cross1_id, rs.cross2_id)
    WHERE s.hops < 5 
        and 
            LOCATE(
                CONCAT(',',
                    CASE
                        WHEN s.current_cross = rs.cross1_id THEN rs.cross2_id
                        ELSE rs.cross1_id
                    END, ',') ,s.visited ) = 0 
        and 
            if( rs.id IN(@bridge1, @bridge2),
            s.bridge_count +1,
            s.bridge_count) <= 1 
        and s.current_cross <> @finish
)
SELECT 
    total_m,
    visited,
    used_segments,
    hops,
    bridge_count
FROM shortestPath
WHERE current_cross = @finish and bridge_count = 1
ORDER BY total_m asc, hops ASC
LIMIT 1