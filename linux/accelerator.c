#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>

int open_physical (int);
void * map_physical (int, unsigned int, unsigned int);
void close_physical (int);
int unmap_physical (void *, unsigned int);

#define HW_BASE 0xff200000
#define HW_SPAN 0x00200000
#define LED_BASE 0x20
#define ACC_BASE 0x2040

int fd; // used to open /dev/mem for access to physical addresses
void *HW_virtual; // used to map physical addresses
volatile int * led_ptr;
volatile int * acc_ptr;

// Initialize the hardware mapping
int init_hw(void) {
    fd = -1; // used to open /dev/mem for access to physical addresses

    // Create virtual memory access to the SDRAM
    if ((fd = open_physical (fd)) == -1)
        return (-1);
    if ((HW_virtual = map_physical (fd, HW_BASE, HW_SPAN)) == NULL)
        return (-1);

    // Set virtual address pointer
    led_ptr = (int *) (HW_virtual + LED_BASE);
    acc_ptr = (int *) (HW_virtual + ACC_BASE);

    // turn on LED indicators
    *(led_ptr) = 1023;

    return 0;
}

// Release the hardware mapping
int close_hw(void) {

    // turn off LED indicators
    *(led_ptr) = 0;

    unmap_physical (HW_virtual, HW_SPAN); // release the physical-memory mapping
    close_physical (fd); // close /dev/mem

    return 0;
}

// Uses the hardware accelerator to enhance image
int compute_pixel(int p1, int p2, int p3, int p4, int p5, int p6, int p7, int p8, int p9) {
    *(acc_ptr + 1) = p1;
    *(acc_ptr + 2) = p2;
    *(acc_ptr + 3) = p3;
    *(acc_ptr + 4) = p4;
    *(acc_ptr + 5) = p5;
    *(acc_ptr + 6) = p6;
    *(acc_ptr + 7) = p7;
    *(acc_ptr + 8) = p8;
    *(acc_ptr + 9) = p9;
    return (int) (*(acc_ptr) / 100);
}

// Open /dev/mem, if not already done, to give access to physical addresses
int open_physical(int fd)
{
    if (fd == -1)
        if ((fd = open( "/dev/mem", (O_RDWR | O_SYNC))) == -1)
        {
            printf ("ERROR: could not open \"/dev/mem\"...\n");
            return (-1);
        }
    return fd;
}

// Close /dev/mem to give access to physical addresses
void close_physical (int fd)
{
    close (fd);
}

/*
 * Establish a virtual address mapping for the physical addresses starting at base, and
 * extending by span bytes.
 */
void* map_physical(int fd, unsigned int base, unsigned int span)
{
    void *virtual_base;

    // Get a mapping from physical addresses to virtual addresses
    virtual_base = mmap (NULL, span, (PROT_READ | PROT_WRITE), MAP_SHARED, fd, base);
    if (virtual_base == MAP_FAILED)
    {
        printf ("ERROR: mmap() failed...\n");
        close (fd);
        return (NULL);
    }
    return virtual_base;
}

/*
 * Close the previously-opened virtual address mapping
 */
int unmap_physical(void * virtual_base, unsigned int span)
{
    if (munmap (virtual_base, span) != 0)
    {
        printf ("ERROR: munmap() failed...\n");
        return (-1);
    }
    return 0;
}
