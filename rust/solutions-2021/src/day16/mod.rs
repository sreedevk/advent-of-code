mod part1;
mod part2;

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
        [part1::solve(), part2::solve()]
    }
}
