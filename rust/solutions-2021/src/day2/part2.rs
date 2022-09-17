pub struct Part2;
struct Submarine { y: i32, x: i32, aim: i32 }

impl Part2 {
    fn geninst<'a>(input: &'a str) -> Box<dyn Fn(Submarine) -> Submarine + 'a> {
        match input.split(" ").collect::<Vec<&str>>()[..] {
            ["forward", x] => Box::new(|sub: Submarine| -> Submarine {
                let parsedx = x.parse::<i32>().unwrap();
                Submarine{ x: sub.x + parsedx, y: sub.y + parsedx * sub.aim, aim: sub.aim }
            }),
            ["down", x]    => Box::new(|sub: Submarine| -> Submarine {
                Submarine{ x: sub.x, y: sub.y, aim: sub.aim + x.parse::<i32>().unwrap() }
            }),
            ["up", x]      => Box::new(|sub: Submarine| -> Submarine {
                Submarine{ x: sub.x, y: sub.y, aim: sub.aim - x.parse::<i32>().unwrap() }
            }),
            _              => Box::new(|sub: Submarine| -> Submarine {
                sub 
            })
        }
    }

    pub fn solve(raw_data: &str) -> i32 {
        let sub = raw_data
            .split("\n")
            .map(|input| Part2::geninst(input) )
            .collect::<Vec<Box<dyn Fn(Submarine) -> Submarine>>>()
            .into_iter()
            .fold(Submarine { y: 0, x: 0, aim: 0 }, |acc, isq| isq(acc)  );

        sub.x * sub.y
    }
}
