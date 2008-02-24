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
	CalCalendar *daily = findCalendar(@"@inbox");
	if (!daily) {
		NSLog(@"Couldn't find @inbox calendar, please set this calendar up before using this application.");
		return 1;
	}
	CalCalendarStore *calStore = [CalCalendarStore defaultCalendarStore];
	NSDate *midnightLastNight = [NSDate dateWithNaturalLanguageString:@"today at midnight" locale:nil];
	NSDate *justBeforeMidnightTonight = [midnightLastNight addTimeInterval:(60*60*24 - 1)];
	NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate: midnightLastNight
		endDate:justBeforeMidnightTonight calendars:[NSArray arrayWithObject:shadow]];
	NSArray *events = [calStore eventsWithPredicate:predicate];
	for (CalEvent *event in events) {
		CalTask *newTask = [CalTask task];
		newTask.calendar = daily;
		newTask.title = event.title;
		newTask.dueDate = [NSDate date];
		NSError *error;
		[[CalCalendarStore defaultCalendarStore] saveTask:newTask error:&error];
		if (error) {
			NSLog(@"Error while saving task.");
			return 1;
		}
	}
	return 0;
}
