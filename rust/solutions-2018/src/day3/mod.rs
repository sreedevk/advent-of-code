pub struct Day3;
use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{alpha1, digit1, space0},
    combinator::map,
    sequence::tuple,
    IResult,
};
use std::{fs, sync::mpsc::RecvTimeoutError, ops::Range};

#[derive(Debug, Clone)]
struct Claim {
    pub id: u32,
    pub xoffset: u32,
    pub yoffset: u32,
    pub width: u32,
    pub height: u32,
}

struct Rectangle {
    a: (u32, u32), // top left
    b: (u32, u32), // top right,
    c: (u32, u32), // bottom left
    d: (u32, u32), // bottom right
}

impl Rectangle {
    fn new(claim: &Claim) -> Self {
        let tl_x = claim.xoffset;
        let tl_y = claim.yoffset;

        let tr_x = claim.xoffset + claim.width;
        let tr_y = claim.yoffset;

        let bl_x = claim.xoffset;
        let bl_y = claim.yoffset + claim.height;

        let br_x = claim.xoffset + claim.width;
        let br_y = claim.yoffset + claim.height;

        Self {
            a: (tl_x, tl_y),
            b: (tr_x, tr_y),
            c: (bl_x, bl_y),
            d: (br_x, br_y),
        }
    }

    fn overlaps(_rec1: &Rectangle, _rec2: &Rectangle) -> bool {
        true
    }
}

type ParsedClaim<'a> = (
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
    &'a str,
);

impl Claim {
    pub fn new(c: ParsedClaim) -> Self {
        let (_, id, _, _, _, xoffset, _, yoffset, _, _, width, _, height) = c;
        Claim {
            id: u32::from_str_radix(id, 10).unwrap(),
            xoffset: u32::from_str_radix(xoffset, 10).unwrap(),
            yoffset: u32::from_str_radix(yoffset, 10).unwrap(),
            height: u32::from_str_radix(height, 10).unwrap(),
            width: u32::from_str_radix(width, 10).unwrap(),
        }
    }
}

impl Day3 {
    pub fn solve() -> [String; 2] {
        [Self::solve1(), Self::solve2()]
    }

    fn solve1() -> String {
        let claims = Self::parse_data("data/main/2018/day3.txt");
        let overlapping_claims: Vec<Claim> = claims
            .clone()
            .into_iter()
            .filter(|claim| {
                let r1 = Rectangle::new(&claim);
                claims.iter().any(|claim2| {
                    let r2 = Rectangle::new(claim2);
                    Rectangle::overlaps(&r1, &r2)
                })
            })
            .collect();

        String::from(format!("{}", overlapping_claims.len()))
    }

    fn solve2() -> String {
        String::from("test")
    }

    fn parse_claim(raw_claim: &str) -> IResult<&str, Claim> {
        map(
            tuple((
                tag("#"),
                digit1,
                space0,
                tag("@"),
                space0,
                digit1,
                tag(","),
                digit1,
                tag(":"),
                space0,
                digit1,
                tag("x"),
                digit1,
            )),
            move |c| Claim::new(c),
        )(raw_claim)
    }

    fn parse_data(filepath: &str) -> Vec<Claim> {
        fs::read_to_string(filepath)
            .expect("unable to read file!")
            .trim()
            .split("\n")
            .map(|x| {
                let (_, claim) = Self::parse_claim(x).unwrap();
                claim
            })
            .collect()
    }
}
