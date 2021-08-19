-- 1

SELECT
CONCAT('T',LPAD(REPLACE(`a`.`id`, ',', ''),11,0)) as 'Id',
`a`.`nickname` as 'Nickname',
(CASE
WHEN `a`.`status` = 1 THEN
'Active'
WHEN `a`.`status` = 2 THEN
'Deactivate'
ELSE
'Discontinued'
END) as 'Status',
TRIM(TRAILING '/' FROM REPLACE(
GROUP_CONCAT(
(CASE
WHEN `b`.`role` = 1 THEN
'Trainer'
WHEN `b`.`role` = 2 THEN
'Assessor'
ELSE
'Staff'
END), '/'),',','')
) as 'Roles'
FROM
`trn_teacher` `a`
LEFT OUTER JOIN `trn_teacher_role` `b` ON `a`.`id` = `b`.`teacher_id`
group by `a`.`id`
order by `b`.`id` asc;

-- 2

SELECT 
REPLACE(`a`.`id`, ',', '') as 'Id', 
`a`.`nickname` as 'Nickname',
(SELECT count(`id`) FROM `trn_time_table` where `teacher_id`=`a`.`id` and `status`=1) as 'Open',
(SELECT count(`id`) FROM `trn_time_table` where `teacher_id`=`a`.`id` and `status`=3) as 'Reserved',
(SELECT count(`id`) FROM `trn_evaluation` where `teacher_id`=`a`.`id` and `status`=1) as 'Taught',
(SELECT count(`id`) FROM `trn_evaluation` where `teacher_id`=`a`.`id` and `result`=2) as 'No Show'
FROM
`trn_teacher` `a`
LEFT OUTER JOIN `trn_teacher_role` `b` ON `a`.`id` = `b`.`teacher_id`
WHERE
`a`.`status` in (1,2) and
`b`.`role` in (1,2)
GROUP BY `a`.`id;

-- 
