def LCS_all(dict, word):
    mx = 0
    res = ""
    for word2 in dict:
        crt = LCS_words(word, word2)
        if crt > mx:
            mx = crt
            res = word2
    return (res, mx)


def LCS_words(word, word2):
    N = len(word)
    M = len(word2)
    F = [[0 for i in range(M+1)] for j in range(N+1)]
    res = 0
    for i in range(1, N+1):
        for j in range(1, M+1):
            if word[i-1] == word2[j-1]:
                F[i][j] = max(F[i-1][j-1]+1, F[i-1][j], F[i][j-1])
            else:
                F[i][j] = max(F[i-1][j-1], F[i-1][j], F[i][j-1])
    for i in range(1, N+1):
        res = max(res, F[i][M])
    for j in range(1, M+1):
        res = max(res, F[N][j])
    return res
