import math


def divide(a):
    b = int(a / 2)
    if a % 2 == 1:
        return [b, b + 1]
    return [b, b]


def factorization(a):
    primes = []
    factor = 2
    if a < 2:
        return [a]
    while a > 1:
        while a % factor:
            factor += 1
        primes.append(factor)
        a = int(a / factor)
    return primes


def compress_factors(a):
    is_first_2 = True
    is_first_3 = True
    cnt_2 = 0
    cnt_3 = 0
    result = []
    for i in a:
        if i == 2:
            cnt_2 += 1
            if is_first_2:
                is_first_2 = False
            elif not cnt_2 % 3:
                result.append(8)
        elif i == 3:
            cnt_3 += 1
            if is_first_3:
                is_first_3 = False
            elif not cnt_3 % 2:
                result.append(9)
        else:
            result.append(i)
    if cnt_2 % 3 == 2:
        result.append(4)
    elif cnt_2 % 3 == 1:
        result.append(2)
    if cnt_3 % 2 == 1:
        result.append(3)
    return result


def is_prime(a):
    sqrt = int(math.sqrt(a))
    if a < 2:
        return False
    i = 2
    while a % i and i <= sqrt:
        i += 1
    return sqrt + 1 == i


def number2Aheui(a):
    cnt = -1
    result = ""
    table = [
        "바", "받반타", "반", "받", "밤",
        "발", "밦", "밝", "밣", "밢"
    ]
    if a < 10:
        return table[a]
    if is_prime(a):
        for i in divide(a):
            result += number2Aheui(i)
        result += "다"
        return result
    else:
        for i in compress_factors(factorization(a)):
            result += number2Aheui(i)
            cnt += 1
        for i in range(cnt):
            result += "따"
        return result


def trace2Aheui(a):
    result = ""
    for i in range(len(a)):
        result += number2Aheui(ord(a[i])) + "맣"
    return result
