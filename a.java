public class NewYearChaos {
  private static void minimumBribes(int[] arr) {
    int swapCount = 0;
    for (int i = arr.length - 1; i >= 0; i--) {
      int originalNum = i + 1;
      int currentNum = arr[i];
      if (currentNum != originalNum) {
        int positionBelow = i - 1;
        int numBelow = arr[positionBelow];
        int positionTwoBelow = i - 2;
        int numTwoBelow = arr[positionTwoBelow];
        if (positionBelow >= 0 && numBelow == originalNum) {
          swapCount++;
          swap(arr, i, i - 1);
        } else if (positionTwoBelow >= 0 && numTwoBelow == originalNum) {
          swapCount += 2;
          swap(arr, i - 2, i - 1);
          swap(arr, i - 1, i);
        } else {
          System.out.println("Too chaotic");
          return;
        }
      }
    }
    System.out.println(swapCount);
  }

  private static void swap (int[] arr, int a, int b) {
    int temp = arr[a];
    arr[a] = arr[b];
    arr[b] = temp;
  }
}

/*
Go backwards through the array.

For each element:
- Check if a swap it with the number in front of it will suffice.
  - If so, carry out the one swap.
- Else, check if a with the number two in front of it will.
  - If so, carry out the two swaps.
- Otherwise, too chaotic.

We care about the number in front ending up in the right place, not the number in the ith position.
*/
