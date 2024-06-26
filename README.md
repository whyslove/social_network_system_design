# Traveller social network - System Design

Example o the homework for [course by system design](https://balun.courses/courses/system_design). Traveller social network is a web service, which provides basic social network features tuned for travellers. 

## Functional requirements
- posting travel posts with photos, a short description, and pinning to a specific travel location;
- rating and commenting on other travelers' posts;
- subscribing to other travelers to follow their activity;
- finding popular travel spots and viewing posts from these spots in the form of a TOP places by country and city;
- communicating with other travelers in personal messages;
- viewing other travelers' feeds.

## Non-functional requirements
- DAU 10_000_000 and later increasing
- user makes 40 read requests per day in average
- user makes 3 write requests per day in average
- CIS oriented

- has a seasonal load starting from week before and during the first part of long weekends - on New Year's and May holidays. And also has a slight increase in traffic for all summer months 
- data is stored forever, but we can afford slightly increased response time for getting old posts and comments
- max number of friends is 2k
- max number of posts, comments, messages is unlimited
- user must receive direct messages while online as soon as possible, closed to instantly
- user must receive push notifications if he is offline within 10 seconds
- user must see comments within 30 seconds
- user must see new posts within minute
- availability 99.95

- cross-platform
- syncronized between devices for one person in real time

## Service load

- RPS (read): 4629 (10_000_000 * 40 (ожидаемое количество запросов на чтение) / 86400 (переводим в секунды))
- RPS (write): 347 (10_000_000 * 3 (ожидаемое количество запросов на комментарии или запись) / 86400 (переводим в секунды))
- Traffic (read): As we have pics based system, i would assume that medium service resonse size is 120Kb, thus traffic will be 542 Mb/s
- Traffic (write): As we have one upload picture request among 3 write, i would assume that pic is not compressed so average write request size is 
1Mb, thus traffic for write will be 1Mb/s
- Maximum open connections: 1_000_000 (dau * 0.1)


## Disks
- Total capacity per year: 1Mb/s (Traffic write) * 60 * 60 * 24 * 365 = 30Tb if we does not compress pictures. 
I assume that we will compress pictures, thus we can decrease total capacity by 80% as i guess that 80% is the average rate
of compressing random pictures. Thus we have only 6Tb. 
- IOPS: 4629 + 347 ~= 5000 (from Service Load)
- Traffic per second: 543 Mb/s (from Service Load)

I assume that if we serve static images, we need to serve them fast as nobody likes sites with long downloading pictures. 
So as we mostly serve pictures we must use ssd for them. As SSD i will choose SATA as i do not see necessity in small and high-high
perfomant disks. So let's calculate:

- Disks_for_capacity = 6Tb / 100Tb = 1 
- Disks_for_throughput = 543 / 500 = 2
- Disks_for_iops = 5000 / 500 = 50
- Disks = max(1, 2, 50) = 50