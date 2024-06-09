import math

def bs(i, e, arr):
    if arr[i] == e:
        return i    
    if arr[i] < e:
        return bs(i + math.floor(i/2), e, arr)
    else:
        return bs(i - math.floor(i/2), e, arr)
    
arr = [1, 2, 3, 4, 5, 6, 7, 8, 10]
i = math.floor(len(arr)/2)
print(bs(i, 5, arr))


# binary search
def binary_search(arr, x):
    l = 0
    r = len(arr) - 1
    while l <= r:
        mid = l + (r - l) // 2
        if arr[mid] == x:
            return mid
        elif arr[mid] < x:
            l = mid + 1
        else:
            r = mid - 1
    return -1