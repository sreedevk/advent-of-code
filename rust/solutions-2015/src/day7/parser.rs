use nom::{
    IResult,
    bytes::complete::tag,
    character::complete::{space0, alpha1, digit1}, 
    combinator::map,
    branch::alt,
    sequence::tuple,
};

use super::expression::Value;
use super::expression::Expression;


fn parse_value(input: &str) -> IResult<&str, Value> {
    alt(
        (map(alpha1, |c: &str| Value::Wire(c) ),
            map(digit1, |c: &str| Value::Signal(u16::from_str_radix(c, 10).unwrap()) ))
    )(input)
}

fn parse_not(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((tag("NOT"), space0, parse_value, space0, tag("->"), space0, parse_value)),
        move |c| Expression::not(c)
    )(input)
}

fn parse_and(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((parse_value, space0, tag("AND"), space0, parse_value, space0, tag("->"), space0, parse_value)),
        move |c| Expression::and(c)
    )(input)
}

fn parse_or(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((parse_value, space0, tag("OR"), space0, parse_value, space0, tag("->"), space0, parse_value)),
        move |c| Expression::or(c)
    )(input)
}

fn parse_noop(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((parse_value, space0, tag("->"), space0, parse_value)),
        move |c| Expression::noop(c)
    )(input)
}

fn parse_lshift(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((parse_value, space0, tag("LSHIFT"), space0, parse_value, space0, tag("->"), space0, parse_value)),
        move |c| Expression::lshift(c)
    )(input)
}

fn parse_rshift(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((parse_value, space0, tag("RSHIFT"), space0, parse_value, space0, tag("->"), space0, parse_value)),
        move |c| Expression::rshift(c)
    )(input)

}

pub fn parse_expr(input: &str) -> IResult<&str, Expression> {
    alt((parse_or, parse_and, parse_not, parse_noop, parse_rshift, parse_lshift))(input)
}
