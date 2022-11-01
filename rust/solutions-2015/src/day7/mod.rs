use std::fs;
use std::collections::HashMap;

use nom::{
    IResult,
    bytes::complete::tag,
    character::complete::{space0, alpha1, digit1}, 
    combinator::map,
    branch::alt,
    sequence::tuple,
};

#[derive(Debug, Clone, Copy, Eq, Hash, PartialEq)]
enum Value<'a> {
    Signal(u16),
    Wire(&'a str)
}

type Circuit = HashMap<String, u16>;

#[derive(Debug)]
enum Operation {
    Nop,
    Not,
    And,
    Or,
    RShift,
    LShift
}

#[derive(Debug)]
struct Expression<'a> {
    operation: Operation,
    operands: Vec<Value<'a>>,
    assignment: Value<'a>
}

pub struct Day7;

impl Day7 {
    pub fn solve() -> [String; 2] {
        [
            Self::solve1(),
            String::from("test2")
        ]
    }

    fn solve1() -> String {
        let source = Self::read_file("data/example/2015/day7.txt");
        let parsed = source
            .iter()
            .map(|x| parse_expr(x).unwrap() )
            .map(|(_x, y)| y )
            .fold(Circuit::new(), |crc, x| { x.eval(crc) } );

        format!("{:?}", parsed)
    }

    fn read_file(path: &str) -> Vec<String> {
        fs::read_to_string(path)
            .expect("InvalidFile")
            .trim()
            .split("\n")
            .map(String::from)
            .collect()
    }
}

fn reduce_value(value: Value, circ: &Circuit) -> u16 {
        match value {
            Value::Wire(x) => circ.get(x).unwrap().to_owned(),
            Value::Signal(x) => x
        }
    }

    fn wire_name(value: Value) -> &str {
        if let Value::Wire(wire) = value {
            wire
        }
        else {
            "none"
        }
    }



impl<'a> Expression<'_> {
    fn eval(&self, circ: Circuit) -> Circuit {
        match self.operation {
            Operation::Or => {
                let mut new_circuit = circ.clone();
                let op1 = reduce_value(self.operands[0], &new_circuit);
                let op2 = reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(wire_name(self.assignment).to_owned(), op1 | op2);
                new_circuit
            },
            Operation::And => {
                let mut new_circuit = circ.clone();
                let op1 = reduce_value(self.operands[0], &new_circuit);
                let op2 = reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(wire_name(self.assignment).to_owned(), op1 & op2);
                new_circuit
            },
            Operation::Nop => {
                let mut new_circuit = circ.clone();
                let op1 = reduce_value(self.operands[0], &new_circuit);
                new_circuit.insert(wire_name(self.assignment).to_owned(), op1);
                new_circuit
            },
            Operation::Not => {
                let mut new_circuit = circ.clone();
                let op1 = reduce_value(self.operands[0], &new_circuit);
                new_circuit.insert(wire_name(self.assignment).to_owned(), !op1);
                new_circuit
            },
            Operation::RShift => {
                let mut new_circuit = circ.clone();
                let op1 = reduce_value(self.operands[0], &new_circuit);
                let op2 = reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(wire_name(self.assignment).to_owned(), op1 >> op2);
                new_circuit
            },
            Operation::LShift => {
                let mut new_circuit = circ.clone();
                let op1 = reduce_value(self.operands[0], &new_circuit);
                let op2 = reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(wire_name(self.assignment).to_owned(), op1 << op2);
                new_circuit
            }
        }
    }

    fn not((_, _, op1, _, _, _, dest): (&str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::Not,
            operands: vec![op1],
            assignment: dest
        }
    }

    fn and((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::And,
            operands: vec![op1, op2],
            assignment: dest
        }
    }

    fn or((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::Or,
            operands: vec![op1, op2],
            assignment: dest
        }
    }

    fn noop((val, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::Nop,
            operands: vec![val],
            assignment: dest
        }
    }

    fn lshift((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::LShift,
            operands: vec![op1, op2],
            assignment: dest
        }
    }

    fn rshift((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::RShift,
            operands: vec![op1, op2],
            assignment: dest
        }
    }
}

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

fn parse_expr(input: &str) -> IResult<&str, Expression> {
    alt((parse_or, parse_and, parse_not, parse_noop, parse_rshift, parse_lshift))(input)
}
