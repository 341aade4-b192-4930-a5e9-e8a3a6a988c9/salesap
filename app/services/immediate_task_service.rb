class ImmediateTaskService
  def self.call
    t =
        User.find_by_sql(%Q(
          SELECT DISTINCT ON (user_id)
            users.*, tasks.id as task_id
          FROM users
          LEFT JOIN
            (
              SELECT
                *,
                1 as sort_type,
                deadline as sort_value
              FROM
                tasks
              WHERE
                tasks.completed_at IS NULL AND tasks.deadline > NOW()
              UNION
              SELECT
                *,
                2 as sort_type,
                deadline as sort_value
              FROM
                tasks
              WHERE
                tasks.completed_at IS NULL AND tasks.deadline <= NOW()
              UNION
              SELECT
                *,
                3 as sort_type,
                created_at as sort_value
              FROM
                tasks
              WHERE
                tasks.completed_at IS NULL AND tasks.deadline IS NULL
            ) as tasks
          ON
            users.id = tasks.user_id
          ORDER BY
            user_id ASC,
            sort_type ASC,
            sort_value ASC
        ))

    t.to_s

    t

  end
end