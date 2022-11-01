use super::Circuit;

#[derive(Debug, Clone, Copy, Eq, Hash, PartialEq)]
pub enum Value<'a> {
    Signal(u16),
    Wire(&'a str)
}

#[derive(Debug)]
pub enum Operation {
    Nop,
    Not,
    And,
    Or,
    RShift,
    LShift
}

#[derive(Debug)]
pub struct Expression<'a> {
    operation: Operation,
    operands: Vec<Value<'a>>,
    assignment: Value<'a>
}

impl<'a> Expression<'_> {
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

    pub fn eval(&self, circ: Circuit) -> Circuit {
        match self.operation {
            Operation::Or => {
                let mut new_circuit = circ.clone();
                let op1 = Self::reduce_value(self.operands[0], &new_circuit);
                let op2 = Self::reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(Self::wire_name(self.assignment).to_owned(), op1 | op2);
                new_circuit
            },
            Operation::And => {
                let mut new_circuit = circ.clone();
                let op1 = Self::reduce_value(self.operands[0], &new_circuit);
                let op2 = Self::reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(Self::wire_name(self.assignment).to_owned(), op1 & op2);
                new_circuit
            },
            Operation::Nop => {
                let mut new_circuit = circ.clone();
                let op1 = Self::reduce_value(self.operands[0], &new_circuit);
                new_circuit.insert(Self::wire_name(self.assignment).to_owned(), op1);
                new_circuit
            },
            Operation::Not => {
                let mut new_circuit = circ.clone();
                let op1 = Self::reduce_value(self.operands[0], &new_circuit);
                new_circuit.insert(Self::wire_name(self.assignment).to_owned(), !op1);
                new_circuit
            },
            Operation::RShift => {
                let mut new_circuit = circ.clone();
                let op1 = Self::reduce_value(self.operands[0], &new_circuit);
                let op2 = Self::reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(Self::wire_name(self.assignment).to_owned(), op1 >> op2);
                new_circuit
            },
            Operation::LShift => {
                let mut new_circuit = circ.clone();
                let op1 = Self::reduce_value(self.operands[0], &new_circuit);
                let op2 = Self::reduce_value(self.operands[1], &new_circuit);
                new_circuit.insert(Self::wire_name(self.assignment).to_owned(), op1 << op2);
                new_circuit
            }
        }
    }

    pub fn not((_, _, op1, _, _, _, dest): (&str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::Not,
            operands: vec![op1],
            assignment: dest
        }
    }

    pub fn and((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::And,
            operands: vec![op1, op2],
            assignment: dest
        }
    }

    pub fn or((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::Or,
            operands: vec![op1, op2],
            assignment: dest
        }
    }

    pub fn noop((val, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::Nop,
            operands: vec![val],
            assignment: dest
        }
    }

    pub fn lshift((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::LShift,
            operands: vec![op1, op2],
            assignment: dest
        }
    }

    pub fn rshift((op1, _, _, _, op2, _, _, _, dest): (Value<'a>, &str, &str, &str, Value<'a>, &str, &str, &str, Value<'a>)) -> Expression<'a> {
        Expression {
            operation: Operation::RShift,
            operands: vec![op1, op2],
            assignment: dest
        }
    }
}
