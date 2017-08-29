(module
 (table 0 anyfunc)
 (memory $0 1)
 (export "memory" (memory $0))
 (export "check_point_triangle" (func $check_point_triangle))
 (export "check_triangle_triangle" (func $check_triangle_triangle))
 (func $check_point_triangle (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (param $4 i32) (param $5 i32) (param $6 i32) (param $7 i32) (result i32)
  (local $8 i32)
  (local $9 i32)
  (local $10 i32)
  (local $11 i32)
  (block $label$0
   (br_if $label$0
    (i32.eq
     (i32.mul
      (i32.sub
       (get_local $2)
       (get_local $6)
      )
      (tee_local $8
       (i32.sub
        (get_local $3)
        (get_local $5)
       )
      )
     )
     (i32.mul
      (i32.sub
       (get_local $3)
       (get_local $7)
      )
      (tee_local $9
       (i32.sub
        (get_local $2)
        (get_local $4)
       )
      )
     )
    )
   )
   (br_if $label$0
    (i32.lt_s
     (i32.mul
      (i32.add
       (i32.mul
        (i32.sub
         (tee_local $11
          (i32.div_s
           (i32.add
            (i32.add
             (get_local $5)
             (get_local $3)
            )
            (get_local $7)
           )
           (i32.const 3)
          )
         )
         (get_local $3)
        )
        (get_local $9)
       )
       (i32.mul
        (i32.sub
         (get_local $2)
         (tee_local $10
          (i32.div_s
           (i32.add
            (i32.add
             (get_local $4)
             (get_local $2)
            )
            (get_local $6)
           )
           (i32.const 3)
          )
         )
        )
        (get_local $8)
       )
      )
      (i32.add
       (i32.mul
        (get_local $8)
        (i32.sub
         (get_local $2)
         (get_local $0)
        )
       )
       (i32.mul
        (get_local $9)
        (i32.sub
         (get_local $1)
         (get_local $3)
        )
       )
      )
     )
     (i32.const 0)
    )
   )
   (br_if $label$0
    (i32.lt_s
     (i32.mul
      (i32.add
       (i32.mul
        (i32.sub
         (get_local $11)
         (get_local $5)
        )
        (tee_local $8
         (i32.sub
          (get_local $4)
          (get_local $6)
         )
        )
       )
       (i32.mul
        (i32.sub
         (get_local $4)
         (get_local $10)
        )
        (tee_local $9
         (i32.sub
          (get_local $5)
          (get_local $7)
         )
        )
       )
      )
      (i32.add
       (i32.mul
        (get_local $9)
        (i32.sub
         (get_local $4)
         (get_local $0)
        )
       )
       (i32.mul
        (get_local $8)
        (i32.sub
         (get_local $1)
         (get_local $5)
        )
       )
      )
     )
     (i32.const 0)
    )
   )
   (return
    (i32.xor
     (i32.shr_s
      (i32.mul
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $11)
          (get_local $7)
         )
         (tee_local $2
          (i32.sub
           (get_local $6)
           (get_local $2)
          )
         )
        )
        (i32.mul
         (i32.sub
          (get_local $6)
          (get_local $10)
         )
         (tee_local $3
          (i32.sub
           (get_local $7)
           (get_local $3)
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $1)
          (get_local $7)
         )
         (get_local $2)
        )
        (i32.mul
         (get_local $3)
         (i32.sub
          (get_local $6)
          (get_local $0)
         )
        )
       )
      )
      (i32.const 31)
     )
     (i32.const -1)
    )
   )
  )
  (i32.const 0)
 )
 (func $check_triangle_triangle (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 i32)
  (local $8 i32)
  (local $9 i32)
  (local $10 i32)
  (local $11 i32)
  (local $12 i32)
  (local $13 i32)
  (local $14 i32)
  (local $15 i32)
  (local $16 i32)
  (local $17 i32)
  (local $18 i32)
  (local $19 i32)
  (local $20 i32)
  (local $21 i32)
  (local $22 i32)
  (local $23 i32)
  (local $24 i32)
  (block $label$0
   (block $label$1
    (br_if $label$1
     (i32.gt_s
      (i32.mul
       (tee_local $16
        (i32.add
         (i32.mul
          (i32.sub
           (tee_local $4
            (i32.load
             (get_local $0)
            )
           )
           (tee_local $13
            (i32.load offset=8
             (get_local $2)
            )
           )
          )
          (tee_local $10
           (i32.sub
            (tee_local $8
             (i32.load
              (get_local $1)
             )
            )
            (tee_local $9
             (i32.load offset=4
              (get_local $1)
             )
            )
           )
          )
         )
         (i32.mul
          (i32.sub
           (tee_local $12
            (i32.load offset=8
             (get_local $3)
            )
           )
           (get_local $8)
          )
          (tee_local $6
           (i32.sub
            (get_local $4)
            (tee_local $5
             (i32.load offset=4
              (get_local $0)
             )
            )
           )
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $4)
          (tee_local $11
           (i32.load offset=4
            (get_local $2)
           )
          )
         )
         (get_local $10)
        )
        (i32.mul
         (i32.sub
          (tee_local $7
           (i32.load offset=4
            (get_local $3)
           )
          )
          (get_local $8)
         )
         (get_local $6)
        )
       )
      )
      (i32.const 0)
     )
    )
    (set_local $24
     (i32.const 1)
    )
    (br_if $label$0
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (tee_local $15
          (i32.sub
           (get_local $11)
           (get_local $13)
          )
         )
         (i32.sub
          (get_local $8)
          (get_local $7)
         )
        )
        (i32.mul
         (tee_local $19
          (i32.sub
           (get_local $7)
           (get_local $12)
          )
         )
         (i32.sub
          (get_local $11)
          (get_local $4)
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $15)
         (i32.sub
          (get_local $9)
          (get_local $7)
         )
        )
        (i32.mul
         (get_local $19)
         (i32.sub
          (get_local $11)
          (get_local $5)
         )
        )
       )
      )
      (i32.const 1)
     )
    )
   )
   (block $label$2
    (br_if $label$2
     (i32.gt_s
      (i32.mul
       (tee_local $14
        (i32.add
         (i32.mul
          (i32.sub
           (get_local $4)
           (tee_local $2
            (i32.load
             (get_local $2)
            )
           )
          )
          (get_local $10)
         )
         (i32.mul
          (i32.sub
           (tee_local $3
            (i32.load
             (get_local $3)
            )
           )
           (get_local $8)
          )
          (get_local $6)
         )
        )
       )
       (get_local $16)
      )
      (i32.const 0)
     )
    )
    (set_local $24
     (i32.const 1)
    )
    (br_if $label$0
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (tee_local $16
          (i32.sub
           (get_local $13)
           (get_local $2)
          )
         )
         (i32.sub
          (get_local $8)
          (get_local $12)
         )
        )
        (i32.mul
         (tee_local $15
          (i32.sub
           (get_local $12)
           (get_local $3)
          )
         )
         (i32.sub
          (get_local $13)
          (get_local $4)
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $16)
         (i32.sub
          (get_local $9)
          (get_local $12)
         )
        )
        (i32.mul
         (get_local $15)
         (i32.sub
          (get_local $13)
          (get_local $5)
         )
        )
       )
      )
      (i32.const 1)
     )
    )
   )
   (block $label$3
    (br_if $label$3
     (i32.gt_s
      (i32.mul
       (tee_local $17
        (i32.add
         (i32.mul
          (tee_local $16
           (i32.sub
            (get_local $9)
            (tee_local $1
             (i32.load offset=8
              (get_local $1)
             )
            )
           )
          )
          (i32.sub
           (get_local $5)
           (get_local $2)
          )
         )
         (i32.mul
          (tee_local $15
           (i32.sub
            (get_local $5)
            (tee_local $0
             (i32.load offset=8
              (get_local $0)
             )
            )
           )
          )
          (i32.sub
           (get_local $3)
           (get_local $9)
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $16)
         (i32.sub
          (get_local $5)
          (get_local $11)
         )
        )
        (i32.mul
         (get_local $15)
         (i32.sub
          (get_local $7)
          (get_local $9)
         )
        )
       )
      )
      (i32.const 0)
     )
    )
    (set_local $24
     (i32.const 1)
    )
    (br_if $label$0
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $1)
          (get_local $3)
         )
         (tee_local $19
          (i32.sub
           (get_local $2)
           (get_local $11)
          )
         )
        )
        (i32.mul
         (i32.sub
          (get_local $2)
          (get_local $0)
         )
         (tee_local $18
          (i32.sub
           (get_local $3)
           (get_local $7)
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $19)
         (i32.sub
          (get_local $9)
          (get_local $3)
         )
        )
        (i32.mul
         (i32.sub
          (get_local $2)
          (get_local $5)
         )
         (get_local $18)
        )
       )
      )
      (i32.const 1)
     )
    )
   )
   (block $label$4
    (br_if $label$4
     (i32.gt_s
      (i32.mul
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $5)
          (get_local $13)
         )
         (get_local $16)
        )
        (i32.mul
         (i32.sub
          (get_local $12)
          (get_local $9)
         )
         (get_local $15)
        )
       )
       (get_local $17)
      )
      (i32.const 0)
     )
    )
    (set_local $24
     (i32.const 1)
    )
    (br_if $label$0
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (tee_local $19
          (i32.sub
           (get_local $13)
           (get_local $2)
          )
         )
         (i32.sub
          (get_local $9)
          (get_local $12)
         )
        )
        (i32.mul
         (i32.sub
          (get_local $13)
          (get_local $5)
         )
         (tee_local $18
          (i32.sub
           (get_local $12)
           (get_local $3)
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $19)
         (i32.sub
          (get_local $1)
          (get_local $12)
         )
        )
        (i32.mul
         (i32.sub
          (get_local $13)
          (get_local $0)
         )
         (get_local $18)
        )
       )
      )
      (i32.const 1)
     )
    )
   )
   (block $label$5
    (br_if $label$5
     (i32.gt_s
      (i32.mul
       (tee_local $21
        (i32.add
         (i32.mul
          (i32.sub
           (get_local $0)
           (get_local $11)
          )
          (tee_local $19
           (i32.sub
            (get_local $1)
            (get_local $8)
           )
          )
         )
         (i32.mul
          (i32.sub
           (get_local $7)
           (get_local $1)
          )
          (tee_local $18
           (i32.sub
            (get_local $0)
            (get_local $4)
           )
          )
         )
        )
       )
       (tee_local $20
        (i32.add
         (i32.mul
          (get_local $19)
          (i32.sub
           (get_local $0)
           (get_local $2)
          )
         )
         (i32.mul
          (get_local $18)
          (i32.sub
           (get_local $3)
           (get_local $1)
          )
         )
        )
       )
      )
      (i32.const 0)
     )
    )
    (set_local $24
     (i32.const 1)
    )
    (br_if $label$0
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (tee_local $23
          (i32.sub
           (get_local $2)
           (get_local $11)
          )
         )
         (i32.sub
          (get_local $1)
          (get_local $3)
         )
        )
        (i32.mul
         (tee_local $22
          (i32.sub
           (get_local $3)
           (get_local $7)
          )
         )
         (i32.sub
          (get_local $2)
          (get_local $0)
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $23)
         (i32.sub
          (get_local $8)
          (get_local $3)
         )
        )
        (i32.mul
         (get_local $22)
         (i32.sub
          (get_local $2)
          (get_local $4)
         )
        )
       )
      )
      (i32.const 1)
     )
    )
   )
   (block $label$6
    (br_if $label$6
     (i32.gt_s
      (i32.mul
       (get_local $21)
       (i32.add
        (i32.mul
         (get_local $19)
         (i32.sub
          (get_local $0)
          (get_local $13)
         )
        )
        (i32.mul
         (get_local $18)
         (i32.sub
          (get_local $12)
          (get_local $1)
         )
        )
       )
      )
      (i32.const 0)
     )
    )
    (set_local $24
     (i32.const 1)
    )
    (br_if $label$0
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (tee_local $21
          (i32.sub
           (get_local $11)
           (get_local $13)
          )
         )
         (i32.sub
          (get_local $1)
          (get_local $7)
         )
        )
        (i32.mul
         (i32.sub
          (get_local $11)
          (get_local $0)
         )
         (tee_local $23
          (i32.sub
           (get_local $7)
           (get_local $12)
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $21)
         (i32.sub
          (get_local $8)
          (get_local $7)
         )
        )
        (i32.mul
         (i32.sub
          (get_local $11)
          (get_local $4)
         )
         (get_local $23)
        )
       )
      )
      (i32.const 1)
     )
    )
   )
   (block $label$7
    (br_if $label$7
     (i32.eq
      (i32.mul
       (i32.sub
        (get_local $2)
        (get_local $13)
       )
       (tee_local $24
        (i32.sub
         (get_local $3)
         (get_local $7)
        )
       )
      )
      (i32.mul
       (i32.sub
        (get_local $3)
        (get_local $12)
       )
       (tee_local $21
        (i32.sub
         (get_local $2)
         (get_local $11)
        )
       )
      )
     )
    )
    (br_if $label$7
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (i32.sub
          (tee_local $23
           (i32.div_s
            (i32.add
             (i32.add
              (get_local $3)
              (get_local $7)
             )
             (get_local $12)
            )
            (i32.const 3)
           )
          )
          (get_local $3)
         )
         (get_local $21)
        )
        (i32.mul
         (i32.sub
          (get_local $2)
          (tee_local $22
           (i32.div_s
            (i32.add
             (i32.add
              (get_local $2)
              (get_local $11)
             )
             (get_local $13)
            )
            (i32.const 3)
           )
          )
         )
         (get_local $24)
        )
       )
       (i32.add
        (i32.mul
         (get_local $24)
         (i32.sub
          (get_local $2)
          (get_local $4)
         )
        )
        (i32.mul
         (i32.sub
          (get_local $8)
          (get_local $3)
         )
         (get_local $21)
        )
       )
      )
      (i32.const 0)
     )
    )
    (br_if $label$7
     (i32.lt_s
      (i32.mul
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $23)
          (get_local $7)
         )
         (tee_local $24
          (i32.sub
           (get_local $11)
           (get_local $13)
          )
         )
        )
        (i32.mul
         (i32.sub
          (get_local $11)
          (get_local $22)
         )
         (tee_local $21
          (i32.sub
           (get_local $7)
           (get_local $12)
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (get_local $21)
         (i32.sub
          (get_local $11)
          (get_local $4)
         )
        )
        (i32.mul
         (get_local $24)
         (i32.sub
          (get_local $8)
          (get_local $7)
         )
        )
       )
      )
      (i32.const 0)
     )
    )
    (set_local $24
     (i32.const 1)
    )
    (br_if $label$0
     (i32.gt_s
      (i32.mul
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $23)
          (get_local $12)
         )
         (tee_local $2
          (i32.sub
           (get_local $13)
           (get_local $2)
          )
         )
        )
        (i32.mul
         (i32.sub
          (get_local $13)
          (get_local $22)
         )
         (tee_local $3
          (i32.sub
           (get_local $12)
           (get_local $3)
          )
         )
        )
       )
       (i32.add
        (i32.mul
         (i32.sub
          (get_local $8)
          (get_local $12)
         )
         (get_local $2)
        )
        (i32.mul
         (get_local $3)
         (i32.sub
          (get_local $13)
          (get_local $4)
         )
        )
       )
      )
      (i32.const -1)
     )
    )
   )
   (set_local $24
    (i32.const 0)
   )
   (br_if $label$0
    (i32.eq
     (i32.mul
      (i32.sub
       (get_local $4)
       (get_local $0)
      )
      (get_local $10)
     )
     (i32.mul
      (i32.sub
       (get_local $8)
       (get_local $1)
      )
      (get_local $6)
     )
    )
   )
   (set_local $24
    (i32.const 0)
   )
   (br_if $label$0
    (i32.lt_s
     (i32.mul
      (i32.add
       (i32.mul
        (i32.sub
         (tee_local $2
          (i32.div_s
           (i32.add
            (i32.add
             (get_local $9)
             (get_local $8)
            )
            (get_local $1)
           )
           (i32.const 3)
          )
         )
         (get_local $8)
        )
        (get_local $6)
       )
       (i32.mul
        (i32.sub
         (get_local $4)
         (tee_local $8
          (i32.div_s
           (i32.add
            (i32.add
             (get_local $5)
             (get_local $4)
            )
            (get_local $0)
           )
           (i32.const 3)
          )
         )
        )
        (get_local $10)
       )
      )
      (get_local $14)
     )
     (i32.const 0)
    )
   )
   (set_local $24
    (i32.const 0)
   )
   (br_if $label$0
    (i32.lt_s
     (i32.mul
      (i32.add
       (i32.mul
        (i32.sub
         (get_local $2)
         (get_local $9)
        )
        (get_local $15)
       )
       (i32.mul
        (i32.sub
         (get_local $5)
         (get_local $8)
        )
        (get_local $16)
       )
      )
      (get_local $17)
     )
     (i32.const 0)
    )
   )
   (set_local $24
    (i32.gt_s
     (i32.mul
      (i32.add
       (i32.mul
        (i32.sub
         (get_local $2)
         (get_local $1)
        )
        (get_local $18)
       )
       (i32.mul
        (i32.sub
         (get_local $0)
         (get_local $8)
        )
        (get_local $19)
       )
      )
      (get_local $20)
     )
     (i32.const -1)
    )
   )
  )
  (get_local $24)
 )
)
