use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{alpha1, digit1, space0},
    combinator::map,
    sequence::tuple,
    IResult,
};

use super::expression::Expression;
use super::expression::Value;

fn parse_value(input: &str) -> IResult<&str, Value> {
    alt((
        map(alpha1, Value::Wire),
        map(digit1, |c: &str| Value::Signal(c.parse::<u16>().unwrap())),
    ))(input)
}

fn parse_not(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((
            tag("NOT"),
            space0,
            parse_value,
            space0,
            tag("->"),
            space0,
            parse_value,
        )),
        Expression::not,
    )(input)
}

fn parse_and(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((
            parse_value,
            space0,
            tag("AND"),
            space0,
            parse_value,
            space0,
            tag("->"),
            space0,
            parse_value,
        )),
        Expression::and,
    )(input)
}

fn parse_or(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((
            parse_value,
            space0,
            tag("OR"),
            space0,
            parse_value,
            space0,
            tag("->"),
            space0,
            parse_value,
        )),
        Expression::or,
    )(input)
}

fn parse_noop(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((parse_value, space0, tag("->"), space0, parse_value)),
        Expression::noop,
    )(input)
}

fn parse_lshift(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((
            parse_value,
            space0,
            tag("LSHIFT"),
            space0,
            parse_value,
            space0,
            tag("->"),
            space0,
            parse_value,
        )),
        Expression::lshift,
    )(input)
}

fn parse_rshift(input: &str) -> IResult<&str, Expression> {
    map(
        tuple((
            parse_value,
            space0,
            tag("RSHIFT"),
            space0,
            parse_value,
            space0,
            tag("->"),
            space0,
            parse_value,
        )),
        Expression::rshift,
    )(input)
}

pub fn parse_expr(input: &str) -> IResult<&str, Expression> {
    alt((
        parse_or,
        parse_and,
        parse_not,
        parse_noop,
        parse_rshift,
        parse_lshift,
    ))(input)
}
