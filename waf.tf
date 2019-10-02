resource "aws_wafregional_web_acl" "staging" {
  name        = "staging"
  metric_name = "staging"

  default_action {
    type = "BLOCK"
  }

  rule {
    priority = 7
    rule_id  = "${aws_wafregional_rule.access-from-kachidoki-office.id}"
    type     = "REGULAR"

    action {
      type = "ALLOW"
    }
  }

  rule {
    priority = 8
    rule_id  = "${aws_wafregional_rule.guest-office.id}"
    type     = "REGULAR"

    action {
      type = "ALLOW"
    }
  }

  rule {
    priority = 9
    rule_id  = "${aws_wafregional_rule.enemy-ip-stg.id}"
    type     = "REGULAR"

    action {
      type = "BLOCK"
    }
  }
}

resource "aws_wafregional_web_acl" "production" {
    metric_name = "production"
    name        = "production"

    default_action {
        type = "ALLOW"
    }

    rule {
        priority = 2
        rule_id  = "${aws_wafregional_rule.access-from-kachidoki-office.id}"
        type     = "REGULAR"

        action {
            type = "ALLOW"
        }
    }
    rule {
        priority = 3
        rule_id  = "${aws_wafregional_rule.admin-pages.id}"
        type     = "REGULAR"

        action {
            type = "BLOCK"
        }
    }
    rule {
        priority = 4
        rule_id  = "${aws_wafregional_rule.enemy-ip.id}"
        type     = "REGULAR"

        action {
            type = "BLOCK"
        }
    }
    rule {
        priority = 5
        rule_id  = "${aws_wafregional_rule.enemy-country.id}"
        type     = "REGULAR"

        action {
            type = "BLOCK"
        }
    }
    rule {
        priority = 6
        rule_id  = "${aws_wafregional_rule.not-friend-country.id}"
        type     = "REGULAR"

        action {
            type = "COUNT"
        }
    }
}

//6bfe26f6-4440-4b69-911b-94f4bbc49e3d
resource "aws_wafregional_rule" "access-from-kachidoki-office" {
    metric_name = "accessfromkachidokioffice"
    name        = "access-from-kachidoki-office"

    predicate {
        data_id = "${aws_wafregional_ipset.kachidoki-office.id}"
        negated = false
        type    = "IPMatch"
    }
}

//a9212e38-bfad-4967-bdbb-d461f2715a44
resource "aws_wafregional_rule" "guest-office" {
    metric_name = "guestoffice"
    name        = "guest-office"

    predicate {
        data_id = "${aws_wafregional_ipset.guest-office.id}"
        negated = false
        type    = "IPMatch"
    }
}

//d391651d-3dde-44d4-83af-a6196bd73852
resource "aws_wafregional_rule" "enemy-ip-stg" {
    metric_name = "enemyipstg"
    name        = "enemy-ip-stg"

    predicate {
        data_id = "${aws_wafregional_ipset.enemy-ip-stg.id}"
        negated = false
        type    = "IPMatch"
    }
}

//d42e723b-a799-4fc7-84fc-fe798136aa84
resource "aws_wafregional_rule" "admin-pages" {
    metric_name = "adminpages"
    name        = "admin-pages"

    predicate {
        data_id = "${aws_wafregional_ipset.kachidoki-office.id}"
        negated = true
        type    = "IPMatch"
    }
    predicate {
        data_id = "${aws_wafregional_byte_match_set.admin-pages.id}"
        negated = false
        type    = "ByteMatch"
    }
}

//f1017678-bb10-43b4-bb36-1a9ae8e8d730
resource "aws_wafregional_rule" "enemy-ip" {
    metric_name = "enemyip"
    name        = "enemy-ip"

    predicate {
        data_id = "${aws_wafregional_ipset.enemy-ip.id}"
        negated = false
        type    = "IPMatch"
    }
}

//9542817a-78e7-4b7e-89d3-474e19571b82
resource "aws_wafregional_rule" "enemy-country" {
    metric_name = "enemycountry"
    name        = "enemy-country"

    predicate {
        data_id = "${aws_wafregional_geo_match_set.enemy-country.id}"
        negated = false
        type    = "GeoMatch"
    }
}

//95b6350a-c91d-4e31-9ed7-5a8236417824
resource "aws_wafregional_rule" "not-friend-country" {
    metric_name = "notfriendcountry"
    name        = "not-friend-country"

    predicate {
        data_id = "${aws_wafregional_geo_match_set.friend-country.id}"
        negated = true
        type    = "GeoMatch"
    }
}

//cbb7c63c-d7f9-4bd2-aad7-535da1671606
resource "aws_wafregional_geo_match_set" "enemy-country" {
    name = "enemy-country"

    geo_match_constraint {
        type  = "Country"
        value = "CN"
    }
    geo_match_constraint {
        type  = "Country"
        value = "DE"
    }
    geo_match_constraint {
        type  = "Country"
        value = "FR"
    }
    geo_match_constraint {
        type  = "Country"
        value = "HK"
    }
    geo_match_constraint {
        type  = "Country"
        value = "KG"
    }
    geo_match_constraint {
        type  = "Country"
        value = "MX"
    }
    geo_match_constraint {
        type  = "Country"
        value = "NL"
    }
}

//2f47c84b-fe86-4b03-908d-1a00c9b99b6a
resource "aws_wafregional_geo_match_set" "friend-country" {
    name = "friend-country"

    geo_match_constraint {
        type  = "Country"
        value = "JP"
    }
}

//1801e36f-051d-499d-9e61-ca39ee472670
resource "aws_wafregional_ipset" "enemy-ip" {
    name = "enemy-ip"

    ip_set_descriptor {
        type  = "IPV4"
        value = "106.130.211.4/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "107.181.78.166/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "119.92.179.109/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "123.255.134.191/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "124.142.32.202/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "157.119.97.163/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "169.38.85.78/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "169.57.142.75/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "169.57.142.79/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "178.159.37.126/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "178.159.37.23/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "178.159.37.88/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "180.232.1.246/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "185.130.184.200/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "202.55.118.101/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "222.8.252.83/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "31.184.238.101/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "39.110.205.167/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "46.166.143.119/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "85.203.47.67/32"
    }
}

//4591dd68-e33b-41c6-8011-0b3cbaee16da
resource "aws_wafregional_ipset" "kachidoki-office" {
    name = "kachidoki-office"

    ip_set_descriptor {
        type  = "IPV4"
        value = "114.160.214.152/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "118.103.95.42/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "163.139.159.138/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "39.110.205.167/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "52.199.60.79/32"
    }
}

//4c216d63-78b3-4e39-83ee-9a1833185df4
resource "aws_wafregional_ipset" "enemy-ip-stg" {
    name = "enemy-ip-stg"

    ip_set_descriptor {
        type  = "IPV4"
        value = "39.110.205.167/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "49.212.135.68/32"
    }
}

//e5bcedfc-fc56-43c2-89e1-d179819d369a
resource "aws_wafregional_ipset" "guest-office" {
    name = "guest-office"

    ip_set_descriptor {
        type  = "IPV4"
        value = "122.249.156.113/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "150.249.212.68/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "160.16.234.149/32"
    }
    ip_set_descriptor {
        type  = "IPV4"
        value = "49.212.135.68/32"
    }
}

//95627ea8-4529-4c27-bd93-b8f94512745e
resource "aws_wafregional_byte_match_set" "admin-pages" {
    name = "admin-pages"

    byte_match_tuples {
        positional_constraint = "STARTS_WITH"
        target_string         = "/admin"
        text_transformation   = "NONE"

        field_to_match {
            type = "URI"
        }
    }
}
