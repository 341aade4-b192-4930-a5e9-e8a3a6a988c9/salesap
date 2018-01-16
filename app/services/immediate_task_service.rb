class ImmediateTaskService
  def self.call
    t =
        User.joins(%Q(
          LEFT JOIN
            (
              SELECT DISTINCT ON (user_id)
                *
              FROM
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
                ) as marked_tasks
              ORDER BY
                user_id ASC,
                sort_type ASC,
                sort_value ASC
            ) as ordered_tasks
          ON
            users.id = ordered_tasks.user_id
        )).all

    t.to_sql

    t

  end
end