pub struct Problem;
struct Submarine { y: i32, x: i32 }
struct Instruction { x: i32, y: i32 }

impl Problem {
    fn process(sub: &Submarine, instruction: &Instruction) -> Submarine {
        Submarine { x: sub.x + instruction.x, y: sub.y + instruction.y }
    }

    fn geninst(raw: &str) -> Instruction {
        match raw.split(" ").collect::<Vec<&str>>()[..] {
            ["forward", x] => Instruction{ x: x.parse::<i32>().unwrap(), y: 0 },
            ["down", x]    => Instruction{ x: 0, y: x.parse::<i32>().unwrap() },
            ["up", x]      => Instruction{ x: 0, y: (0 - x.parse::<i32>().unwrap())  },
            _              => Instruction{ x: 0, y: 0 }
        }
    }

    pub fn solve(raw_data: &str) -> i32 {
        let sub = raw_data
            .split("\n")
            .map(|input| Problem::geninst(input) )
            .collect::<Vec<Instruction>>()
            .into_iter()
            .fold(Submarine { y: 0, x: 0 }, |acc, isq| Problem::process(&acc, &isq) );

        sub.x * sub.y
    }
}
