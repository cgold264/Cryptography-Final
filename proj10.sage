import math

def txt_to_asc(msg_in):      
  msg_idx = list(map(ord,msg_in))
  return msg_idx

def padding(message):
    pad_len = 16 - (len(message) % 16)
    padded_message = message
    for i in range(0, pad_len):
        padded_message += "i"    
    return padded_message

def asc_to_txt(msg_in):
  m = map(chr,msg_in)
  m = ''.join(m)
  return m

def make_S():
    pi_digits = str(numerical_approx(pi, digits=(3*256)))[2:]
    pi_list = [int((pi_digits[i:i+3])) for i in range(0, len(pi_digits), 3)]
    S = [x % 256 for x in pi_list]
    return S

# Function to calculate the checksum
def checksum(M, S):
    C = [0] * 16
    L = 0
    N = len(M) / 16
    for i in range(N - 1):
        # Checksum block i
        for j in range(16):
            c = M[i*16 + j]
            C[j] = S[c ^^ L]
            L = C[j]
    return M + C

def hash(M, S):
    result = []
    N = len(M)
    N_blocks = N / 16 - 1
    for i in range(N_blocks):
        X = M[i*16:i*16+16]
        X.extend([0] * 32)
        for j in range(16): 
            X[16+j] = M[i*16+j]
            X[32+j] = X[16+j] ^^ X[j]

        t = 0

        for j in range(18):
            for k in range(48):
                t = X[k] ^^ S[t]
                X[k] = X[k] ^^ S[t]
            t = (t + j) % 256
        result.extend(X[:16])
    return result

def md2(message):
    S = make_S()
    M = txt_to_asc(padding(message))
    checksum_result = checksum(M, S)
    hash_result = hash(checksum_result, S)
    hash_text = asc_to_txt(hash_result)
    return hash_text

# Example usage
print(md2("A dog"))
print(md2('To see a World in a Grain of Sand'))
print(md2('A cog'))
