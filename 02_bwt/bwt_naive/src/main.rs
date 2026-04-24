
fn main() {
    let characters: Vec<char> = "BANANA.".chars().collect();
	let encoded: String = bwt_encode(characters.as_slice()).into_iter().collect();
    println!("Encoded: {}", encoded);

    let characters: Vec<char> = encoded.chars().collect();
    let decoded: String = bwt_decode(&characters.as_slice()).into_iter().collect();
    println!("Encoded: {}", decoded);
}

fn bwt_encode(text: &[char]) -> Vec<char> {
    let count = text.len();
    let mut permutations = Vec::with_capacity(count);
    for i in 0..count {
        let mut permutation = text.to_owned();
        permutation.rotate_right(i);
        permutations.push(permutation);
    }
    permutations.sort();
    permutations.into_iter().map(|p| p[p.len() - 1]).collect()
}

fn bwt_decode(text: &[char]) -> Vec<char> {
    let count = text.len();
    let mut permutations = vec![Vec::with_capacity(text.len()); count];
    for _ in 0..count {
        text.iter().enumerate().for_each(|(i, c)| permutations[i].insert(0, *c));
        permutations.sort()
    }
    permutations.into_iter().filter(|s| s.ends_with(&['.'])).nth(0).unwrap()
}