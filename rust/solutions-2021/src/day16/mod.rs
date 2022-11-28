pub struct Day16;

#[derive(Debug)]
pub enum PacketType {
    Literal,
    Operation,
}

#[derive(Debug)]
pub struct Packet {
    pub version: u8,
    pub ptype: PacketType,
    pub data: Vec<u8>,
}

impl Day16 {
    pub fn solve() -> [String; 2] {
        [Self::solve1(), Self::solve2()]
    }

    fn parse_version(packets: &String) -> u8 {
        u8::from_str_radix(&packets[0..3], 2).unwrap()
    }

    fn parse_type(packets: &String) -> PacketType {
        let raw_type = u8::from_str_radix(&packets[3..6], 2).unwrap();
        match raw_type {
            4 => PacketType::Literal,
            _ => PacketType::Operation,
        }
    }

    fn parse_data(raw_data: &String) -> Vec<u8> {
        let _raw_packets = raw_data
            .chars()
            .collect::<Vec<char>>()
            .chunks(5)
            .map(|c| Vec::from(c))
            .collect::<Vec<Vec<char>>>();

        vec![1, 2, 3]
    }

    fn parse_packet(raw_bytes: &String) -> Packet {
        let pkt_binary = raw_bytes
            .chars()
            .map(|c| c.to_digit(16).unwrap())
            .map(|d| format!("{:04b}", d))
            .fold(String::new(), |acc, s| acc + s.as_str());

        let pkt_version = Self::parse_version(&pkt_binary);
        let pkt_type = Self::parse_type(&pkt_binary);
        let pkt_data = Self::parse_data(&String::from(&pkt_binary[6..]));

        Packet {
            version: pkt_version,
            ptype: pkt_type,
            data: pkt_data,
        }
    }

    fn solve1() -> String {
        let input = String::from("D2FE28");
        let pkt = Self::parse_packet(&input);
        String::from(format!("{:?}", pkt))
    }

    fn solve2() -> String {
        String::from("test")
    }
}
