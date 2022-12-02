// use std::fs;
// 
// #[derive(Debug)]
// enum Packet {
//     Literal {
//         version: u8,
//         value: usize,
//     },
//     Operator {
//         version: u8,
//         sub_packets: Vec<Packet>,
//     },
// }
// 
pub fn solve() -> String {
    //let raw_bin = to_binary(read_raw());
    //let packet = to_packet(raw_bin);
    String::from("UNSOLVED")
}

// fn parse_literal(bin: String) -> Packet {
//     let version = u8::from_str_radix(&bin[0..3], 2).unwrap();
//     let data_bits = &bin[6..].chars().collect::<Vec<char>>();
//     let value = parse_data_bits(&data_bits);
//     Packet::Literal { version, value }
// }
// 
// fn parse_data_bits(bin: &Vec<char>) -> usize {
//     let mut raw: String = String::new();
//     for nibble in bin.chunks(5) {
//         raw += &String::from_iter(&nibble[1..]);
// 
//         if nibble[0] == '0' {
//             break;
//         }
//     }
// 
//     usize::from_str_radix(&raw, 2).unwrap()
// }
// 
// fn parse_operator(bin: String) -> Packet {
//     let version = u8::from_str_radix(&bin[0..3], 2).unwrap();
//     let length_type_id = &bin[6..7];
//     match length_type_id {
//         "0" => {
//             let sub_packet_size = usize::from_str_radix(&bin[7..22], 2).unwrap();
//             let raw_sub_packets = &bin[22..(22 + sub_packet_size)];
//             // let sub_packets = to_packet()
//         }
//         "1" => {}
//         _ => panic!("INVALID LENGTH TYPE ID"),
//     }
//     dbg!(length_type_id);
//     Packet::Operator {
//         version,
//         sub_packets: vec![],
//     }
// }
// 
// fn to_packet(bin: String) -> Packet {
//     let packet_type = u8::from_str_radix(&bin[3..6], 2).unwrap();
//     match packet_type {
//         4 => parse_literal(bin),
//         _ => parse_operator(bin),
//     }
// }
// 
// fn to_binary(raw: String) -> String {
//     raw.chars().into_iter().fold(String::new(), |ostr, chr| {
//         let cstr = chr.to_string();
//         let decimal = u8::from_str_radix(&cstr, 16).unwrap();
//         ostr + &format!("{:04b}", decimal)
//     })
// }
// 
// fn read_raw() -> String {
//     return String::from("38006F45291200");
//     fs::read_to_string("data/example/2021/day16.txt")
//         .unwrap()
//         .trim()
//         .to_string()
// }
