
Table "posts" {
  "id" INTEGER [pk]
  "user_id" INTEGER
  "description" TEXT
  "attaches_ids" "UUID[]"
  "location_id" INTEGER
  "created_at" TIMESTAMP
  "updated_at" TIMESTAMP
}

Table "attaches" {
  "id" UUID [pk]
  "bytes" BYTEA


  Note {
  '''
    Таблица attaches не имеет связей на данной диаграмме, так как предполагается, что 
    мы храним в реляционной базе только id аттачей, по которым мы можем забирать их 
    из хранилища вроде S3 (не очень вариант), CDN (потенциально более правильный вариант)
  '''
  }
}

Table "messages" {
  "id" INTEGER [pk]
  "sender_id" INTEGER
  "receiver_id" INTEGER
  "message" TEXT
  "attaches_ids" "UUID[]"
  "created_at" TIMESTAMP
  "updated_at" TIMESTAMP
}

Table "locations" {
  "id" INTEGER [pk]
  "name" TEXT
  "longitude" FLOAT
  "latitude" FLOAT
}

Table "comments" {
  "id" INTEGER [pk]
  "user_id" INTEGER
  "post_id" INTEGER
  "comment" TEXT
  "attaches_ids" "UUID[]"
  "replied_to" INTEGER
  "created_at" TIMESTAMP
  "updated_at" TIMESTAMP
}

Table "top_place_posts" {
  "top_place_id" INTEGER
  "post_id" INTEGER
  "order" INTEGER
  "created_at" TIMESTAMP
  "updated_at" TIMESTAMP

  Indexes {
    (top_place_id, post_id) [pk]
  }
}

Table "top_places" {
  "id" INTEGER [pk]
  "country_id" INTEGER
  "city_id" INTEGER
  "description" TEXT
  "attaches_ids" "UUID[]"
  "location_id" INTEGER
  "created_at" TIMESTAMP
  "updated_at" TIMESTAMP
}

Table "followers" {
  "who" INTEGER
  "whom" INTEGER

  Indexes {
    (who, whom) [pk]
  }
}

Table "users" {
  "id" INTEGER [pk]
  "name" TEXT
  "surname" TEXT
}

Ref "fk_follower_who":"followers"."who" < "users"."id"

Ref "fk_comm_user":"comments"."user_id" - "users".id

Ref "fk_post_user":"posts"."user_id" - "users".id

Ref "fk_msg_sender":"messages"."sender_id" - "users".id

Ref "fk_msg_receiver":"messages"."receiver_id" - "users".id

Ref "fk_follower_who":"followers"."whom" < "users"."id"

Ref "fk_location_id":"locations"."id" < "posts"."location_id"

Ref "fk_post_id":"posts"."id" < "comments"."post_id"

Ref "fk_replied_to":"comments"."id" < "comments"."replied_to"

Ref "fk_top_place_id":"top_places"."id" < "top_place_posts"."top_place_id"

Ref "fk_post_id":"posts"."id" < "top_place_posts"."post_id"

Ref "fk_location_id":"locations"."id" < "top_places"."location_id"

Ref: "locations"."id" < "messages"."id"

Ref: "top_place_posts"."post_id" < "top_place_posts"."updated_at"

