#import <Cocoa/Cocoa.h>
#import "CalendarStore/CalendarStore.h"

CalCalendar* findCalendar(NSString *calName) {
	NSArray *calendars = [[CalCalendarStore  defaultCalendarStore] calendars];
	for (CalCalendar *cal in calendars) {
		if ([cal.title isEqualTo:calName]) {
			return cal;
		}
	}
	return nil;

}
int main(int argc, char *argv[])
{
	CalCalendar *shadow = findCalendar(@"Shadow");
	CalCalendar *daily = findCalendar(@"@daily");	
	if (!daily) {
		NSLog(@"Couldn't find @daily calendar, please set this calendar up before using this application.");
	}
	CalCalendarStore *calStore = [CalCalendarStore defaultCalendarStore];
	NSDate *midnightLastNight = [NSDate dateWithNaturalLanguageString:@"today at midnight" locale:nil];
	NSDate *justBeforeMidnightTonight = [midnightLastNight addTimeInterval:(60*60*24 - 1)];
	NSLog(@"say what - %@", justBeforeMidnightTonight);
	NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate: midnightLastNight
		endDate:justBeforeMidnightTonight calendars:[NSArray arrayWithObject:shadow]];
	NSArray *events = [calStore eventsWithPredicate:predicate];
	NSLog(@"logging");
	for (CalEvent *event in events) {
		NSLog(@"%@", event.title);
	}
	return 0;
}
