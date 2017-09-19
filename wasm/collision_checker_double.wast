(module
 (table 0 anyfunc)
 (memory $0 1)
 (export "memory" (memory $0))
 (export "check_point_triangle" (func $check_point_triangle))
 (export "check_triangle_triangle" (func $check_triangle_triangle))
 (func $check_point_triangle (param $0 f32) (param $1 f32) (param $2 f32) (param $3 f32) (param $4 f32) (param $5 f32) (param $6 f32) (param $7 f32) (result i32)
  (local $8 f32)
  (local $9 f32)
  (local $10 f32)
  (local $11 f32)
  (local $12 i32)
  (set_local $12
   (i32.const 0)
  )
  (block $label$0
   (br_if $label$0
    (f32.eq
     (f32.mul
      (tee_local $8
       (f32.sub
        (get_local $3)
        (get_local $5)
       )
      )
      (f32.sub
       (get_local $2)
       (get_local $6)
      )
     )
     (f32.mul
      (tee_local $9
       (f32.sub
        (get_local $2)
        (get_local $4)
       )
      )
      (f32.sub
       (get_local $3)
       (get_local $7)
      )
     )
    )
   )
   (br_if $label$0
    (f32.lt
     (f32.mul
      (f32.add
       (f32.mul
        (f32.sub
         (get_local $1)
         (get_local $3)
        )
        (get_local $9)
       )
       (f32.mul
        (f32.sub
         (get_local $2)
         (get_local $0)
        )
        (get_local $8)
       )
      )
      (f32.add
       (f32.mul
        (get_local $8)
        (f32.sub
         (get_local $2)
         (tee_local $10
          (f32.div
           (f32.add
            (f32.add
             (get_local $2)
             (get_local $4)
            )
            (get_local $6)
           )
           (f32.const 3)
          )
         )
        )
       )
       (f32.mul
        (get_local $9)
        (f32.sub
         (tee_local $8
          (f32.div
           (f32.add
            (f32.add
             (get_local $3)
             (get_local $5)
            )
            (get_local $7)
           )
           (f32.const 3)
          )
         )
         (get_local $3)
        )
       )
      )
     )
     (f32.const 0)
    )
   )
   (br_if $label$0
    (f32.lt
     (f32.mul
      (f32.add
       (f32.mul
        (f32.sub
         (get_local $1)
         (get_local $5)
        )
        (tee_local $9
         (f32.sub
          (get_local $4)
          (get_local $6)
         )
        )
       )
       (f32.mul
        (f32.sub
         (get_local $4)
         (get_local $0)
        )
        (tee_local $11
         (f32.sub
          (get_local $5)
          (get_local $7)
         )
        )
       )
      )
      (f32.add
       (f32.mul
        (get_local $11)
        (f32.sub
         (get_local $4)
         (get_local $10)
        )
       )
       (f32.mul
        (get_local $9)
        (f32.sub
         (get_local $8)
         (get_local $5)
        )
       )
      )
     )
     (f32.const 0)
    )
   )
   (br_if $label$0
    (f32.lt
     (f32.mul
      (f32.add
       (f32.mul
        (tee_local $2
         (f32.sub
          (get_local $6)
          (get_local $2)
         )
        )
        (f32.sub
         (get_local $1)
         (get_local $7)
        )
       )
       (f32.mul
        (f32.sub
         (get_local $6)
         (get_local $0)
        )
        (tee_local $3
         (f32.sub
          (get_local $7)
          (get_local $3)
         )
        )
       )
      )
      (f32.add
       (f32.mul
        (get_local $3)
        (f32.sub
         (get_local $6)
         (get_local $10)
        )
       )
       (f32.mul
        (get_local $2)
        (f32.sub
         (get_local $8)
         (get_local $7)
        )
       )
      )
     )
     (f32.const 0)
    )
   )
   (set_local $12
    (i32.const -1)
   )
  )
  (get_local $12)
 )
 (func $check_triangle_triangle (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32) (result i32)
  (local $4 f32)
  (local $5 f32)
  (local $6 f32)
  (local $7 f32)
  (local $8 f32)
  (local $9 f32)
  (local $10 f32)
  (local $11 f32)
  (local $12 f32)
  (local $13 f32)
  (local $14 f32)
  (local $15 f32)
  (local $16 f32)
  (local $17 f32)
  (local $18 f32)
  (local $19 f32)
  (local $20 f32)
  (local $21 f32)
  (local $22 f32)
  (local $23 f32)
  (local $24 f32)
  (local $25 f32)
  (local $26 f32)
  (local $27 f32)
  (local $28 f32)
  (local $29 i32)
  (block $label$0
   (block $label$1
    (br_if $label$1
     (f32.gt
      (f32.mul
       (f32.add
        (f32.mul
         (tee_local $6
          (f32.sub
           (tee_local $4
            (f32.load
             (get_local $0)
            )
           )
           (tee_local $5
            (f32.load offset=4
             (get_local $0)
            )
           )
          )
         )
         (f32.sub
          (tee_local $7
           (f32.load offset=4
            (get_local $3)
           )
          )
          (tee_local $8
           (f32.load
            (get_local $1)
           )
          )
         )
        )
        (f32.mul
         (tee_local $10
          (f32.sub
           (get_local $8)
           (tee_local $9
            (f32.load offset=4
             (get_local $1)
            )
           )
          )
         )
         (f32.sub
          (get_local $4)
          (tee_local $11
           (f32.load offset=4
            (get_local $2)
           )
          )
         )
        )
       )
       (tee_local $17
        (f32.add
         (f32.mul
          (get_local $6)
          (f32.sub
           (tee_local $12
            (f32.load offset=8
             (get_local $3)
            )
           )
           (get_local $8)
          )
         )
         (f32.mul
          (get_local $10)
          (f32.sub
           (get_local $4)
           (tee_local $13
            (f32.load offset=8
             (get_local $2)
            )
           )
          )
         )
        )
       )
      )
      (f32.const 0)
     )
    )
    (set_local $29
     (i32.const 1)
    )
    (br_if $label$0
     (i32.or
      (f32.le
       (tee_local $14
        (f32.mul
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $11)
            (get_local $4)
           )
           (tee_local $14
            (f32.sub
             (get_local $7)
             (get_local $12)
            )
           )
          )
          (f32.mul
           (f32.sub
            (get_local $8)
            (get_local $7)
           )
           (tee_local $15
            (f32.sub
             (get_local $11)
             (get_local $13)
            )
           )
          )
         )
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $11)
            (get_local $5)
           )
           (get_local $14)
          )
          (f32.mul
           (f32.sub
            (get_local $9)
            (get_local $7)
           )
           (get_local $15)
          )
         )
        )
       )
       (f32.const 0)
      )
      (f32.ne
       (get_local $14)
       (get_local $14)
      )
     )
    )
   )
   (block $label$2
    (br_if $label$2
     (f32.gt
      (f32.mul
       (get_local $17)
       (tee_local $16
        (f32.add
         (f32.mul
          (get_local $6)
          (f32.sub
           (tee_local $14
            (f32.load
             (get_local $3)
            )
           )
           (get_local $8)
          )
         )
         (f32.mul
          (get_local $10)
          (f32.sub
           (get_local $4)
           (tee_local $15
            (f32.load
             (get_local $2)
            )
           )
          )
         )
        )
       )
      )
      (f32.const 0)
     )
    )
    (set_local $29
     (i32.const 1)
    )
    (br_if $label$0
     (i32.or
      (f32.le
       (tee_local $17
        (f32.mul
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $13)
            (get_local $4)
           )
           (tee_local $17
            (f32.sub
             (get_local $12)
             (get_local $14)
            )
           )
          )
          (f32.mul
           (f32.sub
            (get_local $8)
            (get_local $12)
           )
           (tee_local $19
            (f32.sub
             (get_local $13)
             (get_local $15)
            )
           )
          )
         )
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $13)
            (get_local $5)
           )
           (get_local $17)
          )
          (f32.mul
           (f32.sub
            (get_local $9)
            (get_local $12)
           )
           (get_local $19)
          )
         )
        )
       )
       (f32.const 0)
      )
      (f32.ne
       (get_local $17)
       (get_local $17)
      )
     )
    )
   )
   (block $label$3
    (br_if $label$3
     (f32.gt
      (f32.mul
       (tee_local $21
        (f32.add
         (f32.mul
          (f32.sub
           (get_local $14)
           (get_local $9)
          )
          (tee_local $18
           (f32.sub
            (get_local $5)
            (tee_local $17
             (f32.load offset=8
              (get_local $0)
             )
            )
           )
          )
         )
         (f32.mul
          (f32.sub
           (get_local $5)
           (get_local $15)
          )
          (tee_local $20
           (f32.sub
            (get_local $9)
            (tee_local $19
             (f32.load offset=8
              (get_local $1)
             )
            )
           )
          )
         )
        )
       )
       (f32.add
        (f32.mul
         (f32.sub
          (get_local $7)
          (get_local $9)
         )
         (get_local $18)
        )
        (f32.mul
         (f32.sub
          (get_local $5)
          (get_local $11)
         )
         (get_local $20)
        )
       )
      )
      (f32.const 0)
     )
    )
    (set_local $29
     (i32.const 1)
    )
    (br_if $label$0
     (i32.or
      (f32.le
       (tee_local $22
        (f32.mul
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $9)
            (get_local $14)
           )
           (tee_local $22
            (f32.sub
             (get_local $15)
             (get_local $11)
            )
           )
          )
          (f32.mul
           (tee_local $23
            (f32.sub
             (get_local $14)
             (get_local $7)
            )
           )
           (f32.sub
            (get_local $15)
            (get_local $5)
           )
          )
         )
         (f32.add
          (f32.mul
           (get_local $23)
           (f32.sub
            (get_local $15)
            (get_local $17)
           )
          )
          (f32.mul
           (get_local $22)
           (f32.sub
            (get_local $19)
            (get_local $14)
           )
          )
         )
        )
       )
       (f32.const 0)
      )
      (f32.ne
       (get_local $22)
       (get_local $22)
      )
     )
    )
   )
   (block $label$4
    (br_if $label$4
     (f32.gt
      (f32.mul
       (get_local $21)
       (f32.add
        (f32.mul
         (get_local $18)
         (f32.sub
          (get_local $12)
          (get_local $9)
         )
        )
        (f32.mul
         (get_local $20)
         (f32.sub
          (get_local $5)
          (get_local $13)
         )
        )
       )
      )
      (f32.const 0)
     )
    )
    (set_local $29
     (i32.const 1)
    )
    (br_if $label$0
     (i32.or
      (f32.le
       (tee_local $22
        (f32.mul
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $9)
            (get_local $12)
           )
           (tee_local $22
            (f32.sub
             (get_local $13)
             (get_local $15)
            )
           )
          )
          (f32.mul
           (tee_local $23
            (f32.sub
             (get_local $12)
             (get_local $14)
            )
           )
           (f32.sub
            (get_local $13)
            (get_local $5)
           )
          )
         )
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $19)
            (get_local $12)
           )
           (get_local $22)
          )
          (f32.mul
           (get_local $23)
           (f32.sub
            (get_local $13)
            (get_local $17)
           )
          )
         )
        )
       )
       (f32.const 0)
      )
      (f32.ne
       (get_local $22)
       (get_local $22)
      )
     )
    )
   )
   (block $label$5
    (br_if $label$5
     (f32.gt
      (f32.mul
       (tee_local $24
        (f32.add
         (f32.mul
          (f32.sub
           (get_local $14)
           (get_local $19)
          )
          (tee_local $22
           (f32.sub
            (get_local $17)
            (get_local $4)
           )
          )
         )
         (f32.mul
          (f32.sub
           (get_local $17)
           (get_local $15)
          )
          (tee_local $23
           (f32.sub
            (get_local $19)
            (get_local $8)
           )
          )
         )
        )
       )
       (tee_local $25
        (f32.add
         (f32.mul
          (get_local $22)
          (f32.sub
           (get_local $7)
           (get_local $19)
          )
         )
         (f32.mul
          (get_local $23)
          (f32.sub
           (get_local $17)
           (get_local $11)
          )
         )
        )
       )
      )
      (f32.const 0)
     )
    )
    (set_local $29
     (i32.const 1)
    )
    (br_if $label$0
     (i32.or
      (f32.le
       (tee_local $27
        (f32.mul
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $15)
            (get_local $17)
           )
           (tee_local $27
            (f32.sub
             (get_local $14)
             (get_local $7)
            )
           )
          )
          (f32.mul
           (f32.sub
            (get_local $19)
            (get_local $14)
           )
           (tee_local $26
            (f32.sub
             (get_local $15)
             (get_local $11)
            )
           )
          )
         )
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $15)
            (get_local $4)
           )
           (get_local $27)
          )
          (f32.mul
           (f32.sub
            (get_local $8)
            (get_local $14)
           )
           (get_local $26)
          )
         )
        )
       )
       (f32.const 0)
      )
      (f32.ne
       (get_local $27)
       (get_local $27)
      )
     )
    )
   )
   (block $label$6
    (br_if $label$6
     (f32.gt
      (f32.mul
       (f32.add
        (f32.mul
         (f32.sub
          (get_local $12)
          (get_local $19)
         )
         (get_local $22)
        )
        (f32.mul
         (f32.sub
          (get_local $17)
          (get_local $13)
         )
         (get_local $23)
        )
       )
       (get_local $25)
      )
      (f32.const 0)
     )
    )
    (set_local $29
     (i32.const 1)
    )
    (br_if $label$0
     (i32.or
      (f32.le
       (tee_local $25
        (f32.mul
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $19)
            (get_local $7)
           )
           (tee_local $25
            (f32.sub
             (get_local $11)
             (get_local $13)
            )
           )
          )
          (f32.mul
           (tee_local $27
            (f32.sub
             (get_local $7)
             (get_local $12)
            )
           )
           (f32.sub
            (get_local $11)
            (get_local $17)
           )
          )
         )
         (f32.add
          (f32.mul
           (f32.sub
            (get_local $8)
            (get_local $7)
           )
           (get_local $25)
          )
          (f32.mul
           (get_local $27)
           (f32.sub
            (get_local $11)
            (get_local $4)
           )
          )
         )
        )
       )
       (f32.const 0)
      )
      (f32.ne
       (get_local $25)
       (get_local $25)
      )
     )
    )
   )
   (block $label$7
    (br_if $label$7
     (f32.eq
      (f32.mul
       (tee_local $25
        (f32.sub
         (get_local $14)
         (get_local $7)
        )
       )
       (f32.sub
        (get_local $15)
        (get_local $13)
       )
      )
      (f32.mul
       (tee_local $27
        (f32.sub
         (get_local $15)
         (get_local $11)
        )
       )
       (f32.sub
        (get_local $14)
        (get_local $12)
       )
      )
     )
    )
    (br_if $label$7
     (f32.lt
      (f32.mul
       (f32.add
        (f32.mul
         (get_local $27)
         (f32.sub
          (get_local $8)
          (get_local $14)
         )
        )
        (f32.mul
         (f32.sub
          (get_local $15)
          (get_local $4)
         )
         (get_local $25)
        )
       )
       (f32.add
        (f32.mul
         (get_local $25)
         (f32.sub
          (get_local $15)
          (tee_local $26
           (f32.div
            (f32.add
             (f32.add
              (get_local $11)
              (get_local $15)
             )
             (get_local $13)
            )
            (f32.const 3)
           )
          )
         )
        )
        (f32.mul
         (get_local $27)
         (f32.sub
          (tee_local $25
           (f32.div
            (f32.add
             (f32.add
              (get_local $7)
              (get_local $14)
             )
             (get_local $12)
            )
            (f32.const 3)
           )
          )
          (get_local $14)
         )
        )
       )
      )
      (f32.const 0)
     )
    )
    (br_if $label$7
     (f32.lt
      (f32.mul
       (f32.add
        (f32.mul
         (f32.sub
          (get_local $8)
          (get_local $7)
         )
         (tee_local $27
          (f32.sub
           (get_local $11)
           (get_local $13)
          )
         )
        )
        (f32.mul
         (f32.sub
          (get_local $11)
          (get_local $4)
         )
         (tee_local $28
          (f32.sub
           (get_local $7)
           (get_local $12)
          )
         )
        )
       )
       (f32.add
        (f32.mul
         (get_local $28)
         (f32.sub
          (get_local $11)
          (get_local $26)
         )
        )
        (f32.mul
         (get_local $27)
         (f32.sub
          (get_local $25)
          (get_local $7)
         )
        )
       )
      )
      (f32.const 0)
     )
    )
    (set_local $29
     (i32.const 1)
    )
    (br_if $label$0
     (i32.or
      (f32.ge
       (tee_local $7
        (f32.mul
         (f32.add
          (f32.mul
           (tee_local $7
            (f32.sub
             (get_local $13)
             (get_local $15)
            )
           )
           (f32.sub
            (get_local $8)
            (get_local $12)
           )
          )
          (f32.mul
           (f32.sub
            (get_local $13)
            (get_local $4)
           )
           (tee_local $11
            (f32.sub
             (get_local $12)
             (get_local $14)
            )
           )
          )
         )
         (f32.add
          (f32.mul
           (get_local $11)
           (f32.sub
            (get_local $13)
            (get_local $26)
           )
          )
          (f32.mul
           (get_local $7)
           (f32.sub
            (get_local $25)
            (get_local $12)
           )
          )
         )
        )
       )
       (f32.const 0)
      )
      (f32.ne
       (get_local $7)
       (get_local $7)
      )
     )
    )
   )
   (set_local $29
    (i32.const 0)
   )
   (br_if $label$0
    (f32.eq
     (f32.mul
      (get_local $10)
      (f32.sub
       (get_local $4)
       (get_local $17)
      )
     )
     (f32.mul
      (get_local $6)
      (f32.sub
       (get_local $8)
       (get_local $19)
      )
     )
    )
   )
   (br_if $label$0
    (f32.lt
     (f32.mul
      (get_local $16)
      (f32.add
       (f32.mul
        (get_local $10)
        (f32.sub
         (get_local $4)
         (tee_local $7
          (f32.div
           (f32.add
            (f32.add
             (get_local $4)
             (get_local $5)
            )
            (get_local $17)
           )
           (f32.const 3)
          )
         )
        )
       )
       (f32.mul
        (get_local $6)
        (f32.sub
         (tee_local $4
          (f32.div
           (f32.add
            (f32.add
             (get_local $8)
             (get_local $9)
            )
            (get_local $19)
           )
           (f32.const 3)
          )
         )
         (get_local $8)
        )
       )
      )
     )
     (f32.const 0)
    )
   )
   (br_if $label$0
    (f32.lt
     (f32.mul
      (get_local $21)
      (f32.add
       (f32.mul
        (get_local $20)
        (f32.sub
         (get_local $5)
         (get_local $7)
        )
       )
       (f32.mul
        (get_local $18)
        (f32.sub
         (get_local $4)
         (get_local $9)
        )
       )
      )
     )
     (f32.const 0)
    )
   )
   (br_if $label$0
    (f32.lt
     (f32.mul
      (get_local $24)
      (f32.add
       (f32.mul
        (get_local $23)
        (f32.sub
         (get_local $17)
         (get_local $7)
        )
       )
       (f32.mul
        (get_local $22)
        (f32.sub
         (get_local $4)
         (get_local $19)
        )
       )
      )
     )
     (f32.const 0)
    )
   )
   (set_local $29
    (i32.const 1)
   )
  )
  (get_local $29)
 )
)
