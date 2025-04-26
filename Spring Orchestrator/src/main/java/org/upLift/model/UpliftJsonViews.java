package org.upLift.model;

public class UpliftJsonViews {

	/**
	 * Used to mark donor properties that should be visible to all users, as well as
	 * entities that link donor and recipient together to mark properties that should be
	 * included to display public donor info.
	 */
	public static class PublicDonor {

	}

	/**
	 * Used to mark donor properties that should only be visible to the individual donor.
	 */
	public static class PrivateDonor extends PublicDonor {

	}

	/**
	 * Used to mark recipient properties that should be visible to all users, as well as
	 * entities that link donor and recipient together to mark properties that should be
	 * included to display public recipient info.
	 */
	public static class PublicRecipient {

	}

	/**
	 * Used to mark recipient properties that should only be visible to the individual
	 * recipient.
	 */
	public static class PrivateRecipient extends PublicRecipient {

	}

	/**
	 * Used for entities that link donor and recipient together, where public data from
	 * both should be included.
	 */
	public static class PublicBothUsers {

	}

}
