pub struct Day3;
use std::fs;
use nom::{
    IResult,
    bytes::complete::tag,
    character::complete::{space0, alpha1, digit1}, 
    combinator::map,
    branch::alt,
    sequence::tuple,
};

#[derive(Debug)]
struct Claim {
    pub id: u32,
    pub xoffset: u32,
    pub yoffset: u32,
    pub width: u32,
    pub height: u32
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
    &'a str
);

impl Claim {
    pub fn new(c: ParsedClaim) -> Self {
        let (_, id, _, _, _, xoffset, _, yoffset, _, _, width, _, height) = c;
        Claim {
            id: u32::from_str_radix(id, 10).unwrap(),
            xoffset: u32::from_str_radix(xoffset, 10).unwrap(),
            yoffset: u32::from_str_radix(yoffset, 10).unwrap(),
            height: u32::from_str_radix(height, 10).unwrap(),
            width: u32::from_str_radix(width, 10).unwrap()
        }
    }

    pub fn does_overlap(&self, c: &Claim) -> bool {
        true
    }
}

impl Day3 {
    pub fn solve() -> [String; 2] {
        [
            Self::solve1(),
            Self::solve2()
        ] 
    }

    fn solve1() -> String {
        let x = Self::parse_data("data/main/2018/day3.txt");
        dbg!(x);
        
        String::from("test")
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
                digit1
            )),
            move |c| Claim::new(c)
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
